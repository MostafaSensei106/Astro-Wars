package handlers

import (
	"net/http"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/constants"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	"github.com/gin-gonic/gin"
)

type RunHandler struct {
	us domain.RunUseCase
}

func NewRunHandler(usecase domain.RunUseCase) *RunHandler {
	return &RunHandler{
		us: usecase,
	}
}

type runRequest struct {
	Score          int     `json:"score" binding:"required" example:"1500"`
	Duration       int64   `json:"duration" binding:"required" example:"120"`
	CauseOfDeath   string  `json:"cause_of_death" binding:"required" example:"NullPointerException Boss"`
	StageReached   string  `json:"stage_reached" example:"Staging Environment"`
	BugsSquashed   int     `json:"bugs_squashed" example:"45"`
	BossesDefeated int     `json:"bosses_defeated" example:"1"`
	MaxFlowState   int     `json:"max_flow_state" example:"15"`
	Accuracy       float64 `json:"accuracy" example:"85.5"`
	CoffeeCups     int     `json:"coffee_cups" example:"3"`
}

type runResponse struct {
	ID             string  `json:"id" example:"uuid-1234"`
	Score          int     `json:"score" example:"1500"`
	Duration       int64   `json:"duration" example:"120"`
	CauseOfDeath   string  `json:"cause_of_death" example:"NullPointerException Boss"`
	StageReached   string  `json:"stage_reached" example:"Staging Environment"`
	BugsSquashed   int     `json:"bugs_squashed" example:"45"`
	BossesDefeated int     `json:"bosses_defeated" example:"1"`
	MaxFlowState   int     `json:"max_flow_state" example:"15"`
	Accuracy       float64 `json:"accuracy" example:"85.5"`
	CoffeeCups     int     `json:"coffee_cups" example:"3"`
	CreatedAt      string  `json:"created_at" example:"2024-01-01T12:00:00Z"`
}

func mapRunToResponse(r *domain.Runs) runResponse {
	return runResponse{
		ID:             r.ID,
		Score:          r.Score,
		Duration:       r.Duration,
		CauseOfDeath:   r.CauseOfDeath,
		BugsSquashed:   r.BugsSquashed,
		BossesDefeated: r.BossesDefeated,
		MaxFlowState:   r.MaxFlowState,
		Accuracy:       r.Accuracy,
		CoffeeCups:     r.CoffeeCups,
		CreatedAt:      r.CreatedAt.Format("2006-01-02T15:04:05Z07:00"),
	}
}

// CreateRun godoc
// @Summary      Save Game Run
// @Description  Saves the stats of a completed game run for the authenticated user.
// @Tags         runs
// @Accept       json
// @Produce      json
// @Param        request body runRequest true "Run Statistics"
// @Security     BearerAuth
// @Success      201 {object} delivery.Response{data=runResponse} "Run saved successfully."
// @Failure      400 {object} delivery.Response{errors=delivery.ErrorInfo} "Bad Request."
// @Failure      401 {object} delivery.Response{errors=delivery.ErrorInfo} "Unauthorized."
// @Failure      500 {object} delivery.Response{errors=delivery.ErrorInfo} "Internal Server Error."
// @Router       /api/v1/runs/ [post]
func (h *RunHandler) CreateRun(c *gin.Context) {
	var req runRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		delivery.NewResponser(c).Status(http.StatusBadRequest).WithError(http.StatusText(http.StatusBadRequest), err.Error()).Send()
		return
	}

	userID := c.MustGet(constants.JwtField).(string)

	run := domain.Runs{
		UserID:         userID,
		Score:          req.Score,
		Duration:       req.Duration,
		CauseOfDeath:   req.CauseOfDeath,
		BugsSquashed:   req.BugsSquashed,
		BossesDefeated: req.BossesDefeated,
		MaxFlowState:   req.MaxFlowState,
		Accuracy:       req.Accuracy,
		CoffeeCups:     req.CoffeeCups,
	}

	result := h.us.SaveRun(c, &run)
	result.OnSuccess(func(r *domain.Runs) {
		delivery.NewResponser(c).Status(http.StatusCreated).WithData(mapRunToResponse(r)).Send()
	}).OnFailure(func(err error) {
		delivery.NewResponser(c).Status(http.StatusInternalServerError).WithError(http.StatusText(http.StatusInternalServerError), err.Error()).Send()
	})
}

// GetUserRuns godoc
// @Summary      Get User Runs
// @Description  Retrieves all runs for the authenticated user.
// @Tags         runs
// @Produce      json
// @Security     BearerAuth
// @Success      200 {object} delivery.Response{data=[]runResponse} "List of runs retrieved successfully."
// @Failure      401 {object} delivery.Response{errors=delivery.ErrorInfo} "Unauthorized."
// @Failure      500 {object} delivery.Response{errors=delivery.ErrorInfo} "Internal Server Error."
// @Router       /api/v1/runs/ [get]
func (h *RunHandler) GetUserRuns(c *gin.Context) {
	userID := c.MustGet(constants.JwtField).(string)

	result := h.us.GetUserRuns(c, userID)
	result.OnSuccess(func(runs []domain.Runs) {
		var responses []runResponse
		for _, r := range runs {
			responses = append(responses, mapRunToResponse(&r))
		}
		delivery.NewResponser(c).WithData(responses).Send()
	}).OnFailure(func(err error) {
		delivery.NewResponser(c).Status(http.StatusInternalServerError).WithError(http.StatusText(http.StatusInternalServerError), err.Error()).Send()
	})
}
