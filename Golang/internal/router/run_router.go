package router

import (
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery/http/handlers"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery/jwt"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/middleware"
	"github.com/gin-gonic/gin"
)

func SetupRun(rg *gin.RouterGroup, h *handlers.RunHandler, jwtSvc *jwt.JWTService) {
	v1 := rg.Group("/api/v1")
	{
		runGroup := v1.Group("/runs").Use(middleware.AuthMiddleware(jwtSvc))
		{
			runGroup.GET("/", h.GetUserRuns)
			runGroup.POST("/submit", h.CreateRun)
		}
	}
}
