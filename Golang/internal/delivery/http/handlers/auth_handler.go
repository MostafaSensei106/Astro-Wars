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

// Login godoc
// @Summary      User Login
// @Description  Authenticates a user using their username and password. Returns a JWT token and the user's data upon successful authentication.
// @Tags         auth
// @Accept       json
// @Produce      json
// @Param        request body loginRequest true "Login Credentials. Both 'username' and 'password' are required."
// @Success      200 {object} delivery.Response{data=authResponse} "Successfully authenticated. Returns JWT token and User object (excluding password hash)."
// @Failure      400 {object} delivery.Response{errors=delivery.ErrorInfo} "Bad Request. Returned if the JSON body is invalid or missing required fields."
// @Failure      401 {object} delivery.Response{errors=delivery.ErrorInfo} "Unauthorized. Returned if the username or password is incorrect."
// @Failure      500 {object} delivery.Response{errors=delivery.ErrorInfo} "Internal Server Error. Returned if an unexpected server error occurs."
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
// @Success      201 {object} delivery.Response{data=authResponse} "Successfully registered. Returns JWT token and the created User object."
// @Failure      400 {object} delivery.Response{errors=delivery.ErrorInfo} "Bad Request. Returned if the JSON body is invalid, missing required fields, or validation fails (e.g., academic_year out of bounds)."
// @Failure      409 {object} delivery.Response{errors=delivery.ErrorInfo} "Conflict. Returned if the username already exists."
// @Failure      500 {object} delivery.Response{errors=delivery.ErrorInfo} "Internal Server Error. Returned if an unexpected server error occurs."
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

	result := h.usecase.Register(c.Request.Context(), user, req.Password)

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
// @Success      200 {object} delivery.Response{data=authResponse} "Successfully created guest account. Returns JWT token and the guest User object."
// @Failure      400 {object} delivery.Response{errors=delivery.ErrorInfo} "Bad Request. Returned if a request body is sent (guest login accepts no body)."
// @Failure      500 {object} delivery.Response{errors=delivery.ErrorInfo} "Internal Server Error. Returned if an unexpected server error occurs during guest creation."
func (h *AuthHandler) GuestLogin(c *gin.Context) {
	if c.Request.ContentLength > 0 {
		delivery.NewResponser(c).Status(http.StatusBadRequest).WithError(http.StatusText(http.StatusBadRequest), "Guest login does not accept a request body").Send()
		return
	}

	result := h.usecase.GuestLogin(c.Request.Context())

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
// @Param        request body object{email=string} true "User Email. 'email' field is required."
// @Success      200 {object} delivery.Response "Successfully initiated password recovery (placeholder response)."
// @Failure      400 {object} delivery.Response{errors=delivery.ErrorInfo} "Bad Request. Returned if the JSON body is invalid or missing the required 'email' field."
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

// Logout godoc
// @Summary      User Logout
// @Description  Invalidates the user session. (Implementation depends on token handling logic, currently returns success message).
// @Tags         auth
// @Produce      json
// @Success      200 {object} delivery.Response "Successfully logged out."
func (h *AuthHandler) Logout(c *gin.Context) {
	delivery.NewResponser(c).WithData(gin.H{"message": "Logged out successfully"}).Send()
}

// DeleteAccount godoc
// @Summary      Delete Account
// @Description  Removes a user account by their ID.
// @Tags         auth
// @Produce      json
// @Param        id path string true "User ID. Required parameter to identify the user."
// @Success      200 {object} delivery.Response "Successfully deleted the account."
// @Failure      500 {object} delivery.Response{errors=delivery.ErrorInfo} "Internal Server Error. Returned if the deletion fails."
func (h *AuthHandler) DeleteAccount(c *gin.Context) {
	id := c.Param("id")
	result := h.usecase.DeleteUser(c.Request.Context(), id)

	result.OnSuccess(func(success bool) {
		delivery.NewResponser(c).WithData(gin.H{"message": "Account deleted successfully"}).Send()
	}).OnFailure(func(err error) {
		delivery.NewResponser(c).Status(http.StatusInternalServerError).WithError(http.StatusText(http.StatusInternalServerError), err.Error()).Send()
	})
}
