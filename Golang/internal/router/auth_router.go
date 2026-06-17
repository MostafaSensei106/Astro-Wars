package router

import (
	"github.com/gin-gonic/gin"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery/http/handlers"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery/jwt"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/middleware"
)

// SetupAuthRoutes configures the authentication routes with API versioning
func SetupAuthRoutes(rg *gin.RouterGroup, h *handlers.AuthHandler, jwtSvc *jwt.JWTService) {
	v1 := rg.Group("/api/v1")
	{
		authGroup := v1.Group("/auth")
		{
			authGroup.POST("/login", h.Login)
			authGroup.POST("/register", h.Register)
			authGroup.POST("/guest", h.GuestLogin)
			authGroup.POST("/forget-password", h.ForgetPassword)

			// Protected routes
			authGroup.Use(middleware.AuthMiddleware(jwtSvc))
			{
				authGroup.POST("/logout", h.Logout)
				authGroup.DELETE("/account", h.DeleteAccount)
			}
		}
	}
}
