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

type loginRequest struct {
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required"`
}

type authResponse struct {
	Token string       `json:"token"`
	User  *domain.User `json:"user"`
}

type registerRequest struct {
	Fullname     string  `json:"fullname" binding:"required"`
	Username     string  `json:"username" binding:"required"`
	Password     string  `json:"password" binding:"required"`
	College      string  `json:"college" binding:"required"`
	Department   string  `json:"department" binding:"required"`
	AcademicYear int     `json:"academic_year" binding:"required,min=1,max=5"`
	GdgTrack     *string `json:"gdg_track" `
}

func NewAuthHandler(usecase domain.UserUseCase, jwtSvc *jwt.JWTService) *AuthHandler {
	return &AuthHandler{
		usecase: usecase,
		jwtSvc:  jwtSvc,
	}
}

func (h *AuthHandler) Login(c *gin.Context) {
	var req loginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		delivery.NewResponser(c).Status(http.StatusBadRequest).WithError(http.StatusText(http.StatusBadRequest), err.Error()).Send()
		return
	}

	result := h.usecase.Login(c.Request.Context(), req.Username, req.Password)

	result.OnSuccess(func(user *domain.User) {
		token, _ := h.jwtSvc.GenerateToken(user.ID)

		delivery.NewResponser(c).WithData(authResponse{
			Token: token,
			User:  user,
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
	var req registerRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		delivery.NewResponser(c).Status(http.StatusBadRequest).WithError(http.StatusText(http.StatusBadRequest), err.Error()).Send()
		return
	}

	user := &domain.User{
		Fullname: req.Fullname,
		Username: req.Username,
		GdgInfo: domain.GDGInfo{
			College:      req.College,
			Department:   req.Department,
			AcademicYear: req.AcademicYear,
			GdgTrack:     req.GdgTrack,
		},
	}

	result := h.usecase.Register(c.Request.Context(), user, req.Password)

	result.OnSuccess(func(user *domain.User) {
		token, _ := h.jwtSvc.GenerateToken(user.ID)
		delivery.NewResponser(c).Status(http.StatusCreated).WithData(authResponse{
			Token: token,
			User:  user,
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
		delivery.NewResponser(c).WithData(authResponse{
			Token: token,
			User:  user,
		}).Send()
	}).OnFailure(func(err error) {
		delivery.NewResponser(c).Status(http.StatusInternalServerError).WithError(http.StatusText(http.StatusInternalServerError), err.Error()).Send()
	})
}

func (h *AuthHandler) ForgetPassword(c *gin.Context) {
	var req struct {
		Email string `json:"emil" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		delivery.NewResponser(c).Status(http.StatusBadRequest).WithError(http.StatusText(http.StatusBadRequest), err.Error()).Send()
		return
	}

	delivery.NewResponser(c).WithData(gin.H{"message": "Contact Support for Now"}).Send()
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
