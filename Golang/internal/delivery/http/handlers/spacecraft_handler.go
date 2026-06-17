package handlers

import (
	"net/http"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/constants"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	"github.com/gin-gonic/gin"
)

type SpacecraftHandler struct {
	us domain.SpacecraftUseCase
}

func NewSpacecraftHandler(usecase domain.SpacecraftUseCase) *SpacecraftHandler {
	return &SpacecraftHandler{
		us: usecase,
	}
}

type spacecraftRequest struct {
	Name   string `json:"name" binding:"required" example:"Vim Fighter"`
	Rarity string `json:"rarity" example:"Epic"`
}

type spacecraftResponse struct {
	ID         string `json:"id" example:"uuid-5678"`
	Name       string `json:"name" example:"Vim Fighter"`
	Rarity     string `json:"rarity" example:"Epic"`
	Level      int    `json:"level" example:"5"`
	IsActive   bool   `json:"is_active" example:"true"`
	UnlockedAt string `json:"unlocked_at" example:"2024-01-01T12:00:00Z"`
}

func mapSpacecraftToResponse(s *domain.Spacecraft) spacecraftResponse {
	return spacecraftResponse{
		ID:         s.ID,
		Name:       s.Name,
		Rarity:     s.Rarity,
		Level:      s.Level,
		IsActive:   s.IsEquipped,
		UnlockedAt: s.UnlockedAt.Format("2006-01-02T15:04:05Z07:00"),
	}
}

// AddSpacecraft godoc
// @Summary      Add Spacecraft
// @Description  Adds a new spacecraft to the user's garage.
// @Tags         spacecrafts
// @Accept       json
// @Produce      json
// @Param        request body spacecraftRequest true "Spacecraft Data"
// @Security     BearerAuth
// @Success      201 {object} delivery.Response{data=spacecraftResponse} "Spacecraft added successfully."
// @Failure      400 {object} delivery.Response{errors=delivery.ErrorInfo} "Bad Request."
// @Failure      401 {object} delivery.Response{errors=delivery.ErrorInfo} "Unauthorized."
// @Failure      500 {object} delivery.Response{errors=delivery.ErrorInfo} "Internal Server Error."
// @Router       /api/v1/spacecrafts/ [post]
func (h *SpacecraftHandler) AddSpacecraft(c *gin.Context) {
	var req spacecraftRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		delivery.NewResponser(c).Status(http.StatusBadRequest).WithError(http.StatusText(http.StatusBadRequest), err.Error()).Send()
		return
	}

	userID := c.MustGet(constants.JwtField).(string)
	sc := domain.Spacecraft{
		UserID: userID,
		Name:   req.Name,
		Rarity: req.Rarity,
	}

	result := h.us.CreateSpacecraft(c, &sc)
	result.OnSuccess(func(s *domain.Spacecraft) {
		delivery.NewResponser(c).Status(http.StatusCreated).WithData(mapSpacecraftToResponse(s)).Send()
	}).OnFailure(func(err error) {
		delivery.NewResponser(c).Status(http.StatusInternalServerError).WithError(http.StatusText(http.StatusInternalServerError), err.Error()).Send()
	})
}

// GetUserSpacecrafts godoc
// @Summary      Get Spacecrafts
// @Description  Retrieves all spacecrafts owned by the authenticated user.
// @Tags         spacecrafts
// @Produce      json
// @Security     BearerAuth
// @Success      200 {object} delivery.Response{data=[]spacecraftResponse} "List of spacecrafts retrieved successfully."
// @Failure      401 {object} delivery.Response{errors=delivery.ErrorInfo} "Unauthorized."
// @Failure      500 {object} delivery.Response{errors=delivery.ErrorInfo} "Internal Server Error."
// @Router       /api/v1/spacecrafts/ [get]
func (h *SpacecraftHandler) GetUserSpacecrafts(c *gin.Context) {
	userID := c.MustGet(constants.JwtField).(string)

	result := h.us.GetUserSpacecrafts(c, userID)
	result.OnSuccess(func(list []domain.Spacecraft) {
		var responses []spacecraftResponse
		for _, s := range list {
			responses = append(responses, mapSpacecraftToResponse(&s))
		}
		delivery.NewResponser(c).WithData(responses).Send()
	}).OnFailure(func(err error) {
		delivery.NewResponser(c).Status(http.StatusInternalServerError).WithError(http.StatusText(http.StatusInternalServerError), err.Error()).Send()
	})
}

// EquipSpacecraft godoc
// @Summary      Equip Spacecraft
// @Description  Equips a specific spacecraft for the authenticated user, unequipping all others.
// @Tags         spacecrafts
// @Produce      json
// @Param        id path string true "Spacecraft ID"
// @Security     BearerAuth
// @Success      200 {object} delivery.Response{data=spacecraftResponse} "Spacecraft equipped successfully."
// @Failure      400,401,403,404 {object} delivery.Response{errors=delivery.ErrorInfo} "Error equipping spacecraft."
// @Failure      500 {object} delivery.Response{errors=delivery.ErrorInfo} "Internal Server Error."
// @Router       /api/v1/spacecrafts/{id}/equip [patch]
func (h *SpacecraftHandler) EquipSpacecraft(c *gin.Context) {
	userID := c.MustGet(constants.JwtField).(string)
	spacecraftID := c.Param("id")

	result := h.us.EquipSpacecraft(c, userID, spacecraftID)
	result.OnSuccess(func(s *domain.Spacecraft) {
		delivery.NewResponser(c).WithData(mapSpacecraftToResponse(s)).Send()
	}).OnFailure(func(err error) {
		delivery.NewResponser(c).Status(http.StatusInternalServerError).WithError(http.StatusText(http.StatusInternalServerError), err.Error()).Send()
	})
}

// UpgradeSpacecraft godoc
// @Summary      Upgrade Spacecraft
// @Description  Upgrades a specific spacecraft's level for the authenticated user.
// @Tags         spacecrafts
// @Produce      json
// @Param        id path string true "Spacecraft ID"
// @Security     BearerAuth
// @Success      200 {object} delivery.Response{data=spacecraftResponse} "Spacecraft upgraded successfully."
// @Failure      400,401,403,404 {object} delivery.Response{errors=delivery.ErrorInfo} "Error upgrading spacecraft."
// @Failure      500 {object} delivery.Response{errors=delivery.ErrorInfo} "Internal Server Error."
// @Router       /api/v1/spacecrafts/{id}/upgrade [patch]
func (h *SpacecraftHandler) UpgradeSpacecraft(c *gin.Context) {
	userID := c.MustGet(constants.JwtField).(string)
	spacecraftID := c.Param("id")

	result := h.us.UpgradeSpacecraft(c, userID, spacecraftID)
	result.OnSuccess(func(s *domain.Spacecraft) {
		delivery.NewResponser(c).WithData(mapSpacecraftToResponse(s)).Send()
	}).OnFailure(func(err error) {
		delivery.NewResponser(c).Status(http.StatusInternalServerError).WithError(http.StatusText(http.StatusInternalServerError), err.Error()).Send()
	})
}
