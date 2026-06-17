package handlers

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/constants"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery/jwt"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	errs "github.com/MostafaSensei106/Astro-Wars/Golang/internal/errors"
)

type AuthHandler struct {
	us     domain.UserUseCase
	jwtSvc *jwt.JWTService
}

// loginRequest represents the credentials required to authenticate a user.
type loginRequest struct {
	Username string `json:"username" binding:"required" example:"mostafa_sensei"` // User's username (Required)
	Password string `json:"password" binding:"required" example:"P@ssw0rd123"`    // User's password (Required)
}

// authResponse represents the response sent upon successful authentication.
type authResponse struct {
	Token string       `json:"token" example:"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."` // JWT Authentication Token (Required in response)
	User  *domain.User `json:"user"`                                                    // The authenticated user's profile data (Required in response)
}

// registerRequest represents the data required to register a new user.
type registerRequest struct {
	Fullname     string  `json:"fullname" binding:"required" example:"Mostafa Ahmed"`      // Full Name (Required)
	Username     string  `json:"username" binding:"required" example:"mostafa_sensei"`     // Username for login (Required)
	Password     string  `json:"password" binding:"required" example:"P@ssw0rd123"`        // Password for login (Required)
	College      string  `json:"college" binding:"required" example:"Computers & Info"`    // User's college (Required)
	Department   string  `json:"department" binding:"required" example:"Computer Science"` // User's department (Required)
	AcademicYear int     `json:"academic_year" binding:"required,min=1,max=5" example:"3"` // Academic year from 1 to 5 (Required)
	GdgTrack     *string `json:"gdg_track" example:"Flutter" extensions:"x-nullable"`      // GDG Track name (Optional, can be null)
}

// forgetPasswordRequest represents the request body for password recovery
type forgetPasswordRequest struct {
	Email string `json:"email" binding:"required" example:"user@example.com"` // User's email address (Required)
}

func NewAuthHandler(usecase domain.UserUseCase, jwtSvc *jwt.JWTService) *AuthHandler {
	return &AuthHandler{
		us:     usecase,
		jwtSvc: jwtSvc,
	}
}

// Login godoc
// @Summary      User Login
// @Description  Authenticates a user using their username and password. Returns a JWT token and the user's data upon successful authentication.
// @Tags         auth
// @Accept       json
// @Produce      json
// @Param        request body loginRequest true "Login Credentials. Both 'username' and 'password' are required."
// @Router       /api/v1/auth/login [post]
func (h *AuthHandler) Login(c *gin.Context) {
	var req loginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		delivery.NewResponser(c).Status(http.StatusBadRequest).WithError(http.StatusText(http.StatusBadRequest), err.Error()).Send()
		return
	}

	result := h.us.Login(c.Request.Context(), req.Username, req.Password)

	result.OnSuccess(func(user *domain.User) {
		token, _ := h.jwtSvc.GenerateToken(user.ID)

		delivery.NewResponser(c).WithData(authResponse{
			Token: token,
			User:  user,
		}).SecureJSON().Send()
	}).OnFailure(func(err error) {
		status := http.StatusInternalServerError
		message := err.Error()
		if err == domain.ErrInvalidCredentials || err == errs.ErrNotFound {
			status = http.StatusUnauthorized
			message = "Invalid username or password"
		}
		delivery.NewResponser(c).Status(status).WithError(http.StatusText(status), message).Send()
	})
}

// Register godoc
// @Summary      User Registration
// @Description  Creates a new user account with the provided details. Returns a JWT token and the created user's data upon successful registration.
// @Tags         auth
// @Accept       json
// @Produce      json
// @Param        request body registerRequest true "Registration Details. 'fullname', 'username', 'password', 'college', 'department', and 'academic_year' (1-5) are required. 'gdg_track' is optional."
// @Router       /api/v1/auth/register [post]
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
			College:      &req.College,
			Department:   &req.Department,
			AcademicYear: req.AcademicYear,
			GdgTrack:     req.GdgTrack,
		},
	}

	result := h.us.Register(c.Request.Context(), user, req.Password)

	result.OnSuccess(func(user *domain.User) {
		token, _ := h.jwtSvc.GenerateToken(user.ID)
		delivery.NewResponser(c).Status(http.StatusCreated).WithData(authResponse{
			Token: token,
			User:  user,
		}).SecureJSON().Send()
	}).OnFailure(func(err error) {
		status := http.StatusInternalServerError
		message := err.Error()
		if err == errs.ErrConflict {
			status = http.StatusConflict
			message = "Username already exists"
		}
		delivery.NewResponser(c).Status(status).WithError(http.StatusText(status), message).Send()
	})
}

// GuestLogin godoc
// @Summary      Guest Login
// @Description  Creates a temporary guest account. Does not require a request body. Returns a JWT token and the guest user's data.
// @Tags         auth
// @Produce      json
// @Router       /api/v1/auth/guest [post]
func (h *AuthHandler) GuestLogin(c *gin.Context) {
	if c.Request.ContentLength > 0 {
		delivery.NewResponser(c).Status(http.StatusBadRequest).WithError(http.StatusText(http.StatusBadRequest), "Guest login does not accept a request body").Send()
		return
	}

	result := h.us.GuestLogin(c.Request.Context())

	result.OnSuccess(func(user *domain.User) {
		token, _ := h.jwtSvc.GenerateToken(user.ID)
		delivery.NewResponser(c).WithData(authResponse{
			Token: token,
			User:  user,
		}).SecureJSON().Send()
	}).OnFailure(func(err error) {
		delivery.NewResponser(c).Status(http.StatusInternalServerError).WithError(http.StatusText(http.StatusInternalServerError), err.Error()).Send()
	})
}

// ForgetPassword godoc
// @Summary      Forget Password
// @Description  Initiates password recovery (Currently placeholder).
// @Tags         auth
// @Accept       json
// @Produce      json
// @Param        request body forgetPasswordRequest true "User Email. 'email' field is required."
// @Router       /api/v1/auth/forget-password [post]
func (h *AuthHandler) ForgetPassword(c *gin.Context) {
	var req forgetPasswordRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		delivery.NewResponser(c).Status(http.StatusBadRequest).WithError(http.StatusText(http.StatusBadRequest), err.Error()).Send()
		return
	}

	delivery.NewResponser(c).WithData(gin.H{"message": "Contact Support for Now"}).Send()
}

// Logout godoc
// @Summary      User Logout
// @Description  Invalidates the user session by blacklisting the current JWT token.
// @Tags         auth
// @Produce      json
// @Security BearerAuth
// @Router       /api/v1/auth/logout [post]
func (h *AuthHandler) Logout(c *gin.Context) {
	// 1. Invalidate JWT Token
	authHeader := c.GetHeader("Authorization")
	if authHeader != "" {
		parts := strings.SplitN(authHeader, " ", 2)
		if len(parts) == 2 && parts[0] == "Bearer" {
			h.jwtSvc.InvalidateToken(parts[1])
		}
	}

	// 2. Perform usecase logout (e.g. database session clearing)
	userID := c.MustGet(constants.JwtField).(string)
	result := h.us.Logout(c.Request.Context(), userID)

	result.OnSuccess(func(success bool) {
		delivery.NewResponser(c).WithData(gin.H{"message": "Logged out successfully. Token is now expired."}).Send()
	}).OnFailure(func(err error) {
		delivery.NewResponser(c).Status(http.StatusInternalServerError).WithError(http.StatusText(http.StatusInternalServerError), err.Error()).Send()
	})
}

// DeleteAccount godoc
// @Summary      Delete Account
// @Description  Removes a user account by their ID.
// @Tags         auth
// @Produce      json
// @Security BearerAuth
// @Router       /api/v1/auth/account/ [delete]
func (h *AuthHandler) DeleteAccount(c *gin.Context) {
	userID := c.MustGet(constants.JwtField).(string)

	result := h.us.DeleteUser(c.Request.Context(), userID)

	result.OnSuccess(func(success bool) {
		delivery.NewResponser(c).WithData(gin.H{"message": "Account deleted successfully"}).Send()
	}).OnFailure(func(err error) {
		delivery.NewResponser(c).Status(http.StatusInternalServerError).WithError(http.StatusText(http.StatusInternalServerError), err.Error()).Send()
	})
}
