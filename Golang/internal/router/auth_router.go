package router

import (
	"github.com/gin-gonic/gin"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery/http/handlers"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery/jwt"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/middleware"
)

// SetupAuthRoutes configures the authentication routes with API versioning
func SetupAuthRoutes(rg *gin.RouterGroup, authHandler *handlers.AuthHandler, jwtSvc *jwt.JWTService) {
	v1 := rg.Group("/api/v1")
	{
		authGroup := v1.Group("/auth")
		{
			authGroup.POST("/login", authHandler.Login)
			authGroup.POST("/register", authHandler.Register)
			authGroup.POST("/guest", authHandler.GuestLogin)
			authGroup.POST("/forget-password", authHandler.ForgetPassword)

			// Protected routes
			authGroup.Use(middleware.AuthMiddleware(jwtSvc))
			{
				authGroup.POST("/logout", authHandler.Logout)
				authGroup.DELETE("/account/:id", authHandler.DeleteAccount)
			}
		}
	}
}
