package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"

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
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	result := h.usecase.Login(c.Request.Context(), req.Username, req.Password)

	result.OnSuccess(func(user *domain.User) {
		token, _ := h.jwtSvc.GenerateToken(user.ID)
		c.JSON(http.StatusOK, gin.H{
			"token": token,
			"user":  user,
		})
	}).OnFailure(func(err error) {
		status := http.StatusInternalServerError
		if err == domain.ErrInvalidCredentials || err == errs.ErrNotFound {
			status = http.StatusUnauthorized
		}
		c.JSON(status, gin.H{"error": err.Error()})
	})
}

func (h *AuthHandler) Register(c *gin.Context) {
	var req struct {
		Fullname string `json:"fullname" binding:"required"`
		Username string `json:"username" binding:"required"`
		Password string `json:"password" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user := &domain.User{
		Fullname: req.Fullname,
		Username: req.Username,
	}

	result := h.usecase.Register(c.Request.Context(), user, req.Password)

	result.OnSuccess(func(user *domain.User) {
		token, _ := h.jwtSvc.GenerateToken(user.ID)
		c.JSON(http.StatusCreated, gin.H{
			"token": token,
			"user":  user,
		})
	}).OnFailure(func(err error) {
		status := http.StatusInternalServerError
		if err == errs.ErrConflict {
			status = http.StatusConflict
		}
		c.JSON(status, gin.H{"error": err.Error()})
	})
}

func (h *AuthHandler) GuestLogin(c *gin.Context) {
	result := h.usecase.GuestLogin(c.Request.Context())

	result.OnSuccess(func(user *domain.User) {
		token, _ := h.jwtSvc.GenerateToken(user.ID)
		c.JSON(http.StatusOK, gin.H{
			"token": token,
			"user":  user,
		})
	}).OnFailure(func(err error) {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
	})
}

func (h *AuthHandler) ForgetPassword(c *gin.Context) {
	var req struct {
		Username string `json:"username" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "If the account exists, instructions have been sent."})
}

func (h *AuthHandler) Logout(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"message": "Logged out successfully"})
}

func (h *AuthHandler) DeleteAccount(c *gin.Context) {
	id := c.Param("id")
	result := h.usecase.DeleteUser(c.Request.Context(), id)

	result.OnSuccess(func(success bool) {
		c.JSON(http.StatusOK, gin.H{"message": "Account deleted successfully"})
	}).OnFailure(func(err error) {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
	})
}
