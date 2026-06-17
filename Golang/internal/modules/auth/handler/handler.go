package handler

import (
	"net/http"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/core/delivery"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/modules/auth/domain/entities"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/modules/auth/domain/usecases"
	"github.com/gin-gonic/gin"
)

type RegisterRequest struct {
	Name  string `json:"name" binding:"required"`
	Email string `json:"email" binding:"required,email"`
	Track string `json:"track" binding:"required"`

	Grade    int    `json:"grade" binding:"required,min=1,max=5"`
	Password string `json:"password" binding:"required,min=8"`
}

type LoginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

type AuthResponse struct {
	ID    string `json:"id"`
	Name  string `json:"name"`
	Email string `json:"email"`
}

func (r *RegisterRequest) ToEntity() *entities.User {
	return &entities.User{
		Name:     r.Name,
		Email:    r.Email,
		Password: r.Password,
	}
}

func FromEntityToResponse(user *entities.User) AuthResponse {
	if user == nil {
		return AuthResponse{}
	}
	return AuthResponse{
		ID:    user.ID,
		Name:  user.Name,
		Email: user.Email,
	}
}

type AuthHandler struct {
	registerUc *usecases.RegisterUseCase
	loginUc    *usecases.LoginUseCase
}

func New(registerUc *usecases.RegisterUseCase, loginUc *usecases.LoginUseCase) *AuthHandler {
	return &AuthHandler{
		registerUc: registerUc,
		loginUc:    loginUc,
	}
}

func (h *AuthHandler) Register(c *gin.Context) {
	var req RegisterRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		delivery.NewResponser(c).Status(http.StatusBadRequest).WithError(http.StatusText(http.StatusBadRequest), err.Error()).Send()
		return
	}

	userEntity := req.ToEntity()

	res := h.registerUc.Call(c.Request.Context(), userEntity)

	if res.IsFailure() {
		errFailure := res.ErrorOrNull()
		delivery.NewResponser(c).Status(http.StatusInternalServerError).WithError(http.StatusText(http.StatusInternalServerError), (*errFailure).Error()).Send()
		return
	}

	createdUser := res.DataOrNull()
	responseModel := FromEntityToResponse(*createdUser)

	delivery.NewResponser(c).Status(http.StatusCreated).WithData(responseModel).Send()
}

func (h *AuthHandler) Login(c *gin.Context) {
	var req LoginRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		delivery.NewResponser(c).Status(http.StatusBadRequest).WithError(http.StatusText(http.StatusBadRequest), err.Error()).Send()
		return
	}

	res := h.loginUc.Call(c.Request.Context(), usecases.LoginParams{
		Email:    req.Email,
		Password: req.Password,
	})

	if res.IsFailure() {
		errFailure := res.ErrorOrNull()
		delivery.NewResponser(c).Status(http.StatusUnauthorized).WithError(http.StatusText(http.StatusUnauthorized), (*errFailure).Error()).Send()
		return
	}

	user := res.DataOrNull()
	responseModel := FromEntityToResponse(*user)

	delivery.NewResponser(c).Status(http.StatusOK).WithData(responseModel).Send()
}
