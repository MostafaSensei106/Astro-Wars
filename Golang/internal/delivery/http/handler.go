package http

import (
	"net/http"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	"github.com/gin-gonic/gin"
)

type Handler struct {
	authUseCase    domain.AuthUseCase
	runUseCase     domain.RunUseCase
	upgradeUseCase domain.UpgradeUseCase
	userRepo       domain.UserRepository // Used directly for leaderboard here, or can create a LeaderboardUseCase
}

func NewHandler(auth domain.AuthUseCase, run domain.RunUseCase, upgrade domain.UpgradeUseCase, user domain.UserRepository) *Handler {
	return &Handler{
		authUseCase:    auth,
		runUseCase:     run,
		upgradeUseCase: upgrade,
		userRepo:       user,
	}
}

type authPayload struct {
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required"`
}

func (h *Handler) Register(c *gin.Context) {
	var payload authPayload
	if err := c.ShouldBindJSON(&payload); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user, token, err := h.authUseCase.Register(payload.Username, payload.Password)
	if err != nil {
		c.JSON(http.StatusConflict, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"user": user, "token": token})
}

func (h *Handler) Login(c *gin.Context) {
	var payload authPayload
	if err := c.ShouldBindJSON(&payload); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	token, err := h.authUseCase.Login(payload.Username, payload.Password)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": token})
}

func (h *Handler) SyncRun(c *gin.Context) {
	userID := c.MustGet("user_id").(uint)

	var payload domain.RunSyncPayload
	if err := c.ShouldBindJSON(&payload); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	run, err := h.runUseCase.SyncRun(userID, payload)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "run synced successfully", "run": run})
}

func (h *Handler) PurchaseUpgrade(c *gin.Context) {
	userID := c.MustGet("user_id").(uint)

	var payload domain.UpgradePayload
	if err := c.ShouldBindJSON(&payload); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	upgrade, err := h.upgradeUseCase.PurchaseOrUpgrade(userID, payload)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "upgrade purchased/updated", "upgrade": upgrade})
}

func (h *Handler) GetLeaderboard(c *gin.Context) {
	// Simple DB query for now. Should be cached in Redis for high concurrency as per docs.
	users, err := h.userRepo.GetTopPlayers(50)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to fetch leaderboard"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"leaderboard": users})
}
