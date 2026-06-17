package router

import (
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery/http/handlers"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery/jwt"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/middleware"
	"github.com/gin-gonic/gin"
)

func SetupProfile(rg *gin.RouterGroup, h *handlers.ProfileHandler, jwtSvc *jwt.JWTService) {
	v1 := rg.Group("/api/v1")
	{
		profileAuthGroup := v1.Group("/profile").Use(middleware.AuthMiddleware(jwtSvc))
		{
			profileAuthGroup.GET("/", h.GetProfile)
		}
	}

}
