package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery/jwt"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	errs "github.com/MostafaSensei106/Astro-Wars/Golang/internal/errors"
)

type AuthHandler struct {
	usecase domain.UserUseCase
	jwtSvc  *jwt.JWTService
}

func NewAuthHandler(usecase domain.UserUseCase, jwtSvc *jwt.JWTService) *AuthHandler {
	return &AuthHandler{
		usecase: usecase,
		jwtSvc:  jwtSvc,
	}
}

func (h *AuthHandler) Login(c *gin.Context) {
	var req struct {
		Username string `json:"username" binding:"required"`
		Password string `json:"password" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		delivery.NewResponser(c).Status(http.StatusBadRequest).WithError(http.StatusText(http.StatusBadRequest), err.Error())
		return
	}

	result := h.usecase.Login(c.Request.Context(), req.Username, req.Password)

	result.OnSuccess(func(user *domain.User) {
		token, _ := h.jwtSvc.GenerateToken(user.ID)
		delivery.NewResponser(c).WithData(gin.H{
			"token": token,
		}).Send()
	}).OnFailure(func(err error) {
		status := http.StatusInternalServerError
		if err == domain.ErrInvalidCredentials || err == errs.ErrNotFound {
			status = http.StatusUnauthorized
		}
		delivery.NewResponser(c).Status(status).WithError(http.StatusText(status), err.Error()).Send()
	})
}

func (h *AuthHandler) Register(c *gin.Context) {
	var req struct {
		Fullname string `json:"fullname" binding:"required"`
		Username string `json:"username" binding:"required"`
		Password string `json:"password" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		delivery.NewResponser(c).Status(http.StatusBadRequest).WithError(http.StatusText(http.StatusBadRequest), err.Error()).Send()
		return
	}

	user := &domain.User{
		Fullname: req.Fullname,
		Username: req.Username,
	}

	result := h.usecase.Register(c.Request.Context(), user, req.Password)

	result.OnSuccess(func(user *domain.User) {
		token, _ := h.jwtSvc.GenerateToken(user.ID)
		delivery.NewResponser(c).Status(http.StatusCreated).WithData(gin.H{
			"token": token,
		}).Send()
	}).OnFailure(func(err error) {
		status := http.StatusInternalServerError
		if err == errs.ErrConflict {
			status = http.StatusConflict
		}
		delivery.NewResponser(c).Status(status).WithError(http.StatusText(status), err.Error()).Send()
	})
}

func (h *AuthHandler) GuestLogin(c *gin.Context) {
	result := h.usecase.GuestLogin(c.Request.Context())

	result.OnSuccess(func(user *domain.User) {
		token, _ := h.jwtSvc.GenerateToken(user.ID)
		delivery.NewResponser(c).WithData(gin.H{
			"token": token,
			"user":  user,
		}).Send()
	}).OnFailure(func(err error) {
		delivery.NewResponser(c).Status(http.StatusInternalServerError).WithError(http.StatusText(http.StatusInternalServerError), err.Error()).Send()
	})
}

func (h *AuthHandler) ForgetPassword(c *gin.Context) {
	var req struct {
		Username string `json:"username" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		delivery.NewResponser(c).Status(http.StatusBadRequest).WithError(http.StatusText(http.StatusBadRequest), err.Error()).Send()
		return
	}

	delivery.NewResponser(c).WithData(gin.H{"message": "If the account exists, instructions have been sent."}).Send()
}

func (h *AuthHandler) Logout(c *gin.Context) {
	delivery.NewResponser(c).WithData(gin.H{"message": "Logged out successfully"}).Send()
}

func (h *AuthHandler) DeleteAccount(c *gin.Context) {
	id := c.Param("id")
	result := h.usecase.DeleteUser(c.Request.Context(), id)

	result.OnSuccess(func(success bool) {
		delivery.NewResponser(c).WithData(gin.H{"message": "Account deleted successfully"}).Send()
	}).OnFailure(func(err error) {
		delivery.NewResponser(c).Status(http.StatusInternalServerError).WithError(http.StatusText(http.StatusInternalServerError), err.Error()).Send()
	})
}
