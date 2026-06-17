package http

import (
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	"github.com/gin-gonic/gin"
)

func RegisterRoutes(router *gin.Engine, handler *Handler, authUseCase domain.AuthUseCase) {
	// API v1 group
	v1 := router.Group("/api/v1")
	{
		// Public routes
		v1.POST("/auth/register", handler.Register)
		v1.POST("/auth/login", handler.Login)
		v1.GET("/leaderboard", handler.GetLeaderboard)

		// Protected routes
		protected := v1.Group("")
		protected.Use(AuthMiddleware(authUseCase))
		{
			protected.POST("/run/sync", handler.SyncRun)
			protected.POST("/meta/upgrade", handler.PurchaseUpgrade)
		}
	}
}
