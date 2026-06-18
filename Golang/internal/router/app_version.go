package router

import (
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery/http/handlers"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery/jwt"
	"github.com/gin-gonic/gin"
)

func SetupAppVersionRoutes(rg *gin.RouterGroup, h *handlers.AppVersionHandler, jwtSvc *jwt.JWTService) {
	v1 := rg.Group("/api/v1")
	{
		v1 := v1.Group("/app/version")
		{
			v1.POST("/check", h.CheckVersion)
		}
	}
}
