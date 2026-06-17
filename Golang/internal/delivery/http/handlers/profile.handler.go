package handlers

import (
	"net/http"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/constants"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery/jwt"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	"github.com/gin-gonic/gin"
)

type ProfileHandler struct {
	us     domain.UserUseCase
	jwtSvc *jwt.JWTService
}

type UserProfileResponse struct {
	*domain.User
}

type UserProfileRequest struct {
	FullName     string `json:"fullname" binding:"required" example:"Mostafa Ahmed"`
	AcademicYear int    `json:"academic_year" binding:"required,min=1,max=5" example:"3"`
}

func NewProfileHandler(usecase domain.UserUseCase, jwtSrv *jwt.JWTService) *ProfileHandler {
	return &ProfileHandler{
		us:     usecase,
		jwtSvc: jwtSrv,
	}
}

// Profile godoc
// @Summary      User Profile
// @Description
// @Accept       json
// @Produce      json
// @Param
// @Security BearerAuth
// @Router       /api/v1/profile/ [get]
func (h *ProfileHandler) GetProfile(c *gin.Context) {
	id := c.MustGet(constants.JwtField).(string)
	result := h.us.FindUserByID(c, id)

	result.OnSuccess(func(u *domain.User) {
		delivery.NewResponser(c).WithData(&u).Send()
	}).OnFailure(func(err error) {
		delivery.NewResponser(c).Status(http.StatusInternalServerError).WithError(http.StatusText(http.StatusInternalServerError), err.Error())
	})
}

// Profile godoc
// @Summary      User Profile
// @Description
// @Accept       json
// @Produce      json
// @Param
// @Security BearerAuth
// @Router       /api/v1/profile/ [patch]
func (h *ProfileHandler) UpdateProfile(c *gin.Context) {
	var req UserProfileRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		delivery.NewResponser(c).Status(http.StatusBadRequest).WithError(http.StatusText(http.StatusBadRequest), err.Error()).Send()
		return
	}

	id := c.MustGet(constants.JwtField).(string)

	// First, fetch the existing user
	result := h.us.FindUserByID(c, id)
	if result.IsFailure() {
		delivery.NewResponser(c).Status(http.StatusNotFound).WithError(http.StatusText(http.StatusNotFound), "User not found").Send()
		return
	}

	updateResult := h.us.UpdateUser(c, *result.DataOrNull())

	updateResult.OnSuccess(func(u *domain.User) {
		if u.Fullname == "Guest" {
			delivery.NewResponser(c).Status(http.StatusForbidden).WithError(http.StatusText(http.StatusForbidden), "Gest User Can Not Edit Profile").Send()
			return
		}
		delivery.NewResponser(c).WithData(&u).Send()
	}).OnFailure(func(err error) {
		delivery.NewResponser(c).Status(http.StatusInternalServerError).WithError(http.StatusText(http.StatusInternalServerError), err.Error()).Send()
	})
}
