package middleware

import (
	"errors"

	"net/http"
	"strings"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/constants/headers"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery/jwt"
	"github.com/gin-gonic/gin"
)

func AuthMiddleware(jwtService *jwt.JWTService) gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader(headers.AUTHORIZATION)
		if authHeader == "" {
			err := errors.New("authorization header is missing")
			delivery.NewResponser(c).Status(http.StatusUnauthorized).WithError(http.StatusText(http.StatusUnauthorized), err.Error()).Send()
			c.Abort()
			return
		}

		parts := strings.SplitN(authHeader, " ", 2)
		if len(parts) != 2 || parts[0] != "Bearer" {
			err := errors.New("invalid token format")
			delivery.NewResponser(c).Status(http.StatusUnauthorized).WithError(http.StatusText(http.StatusUnauthorized), err.Error()).Send()
			c.Abort()
			return
		}

		claims, err := jwtService.ValidateToken(parts[1])
		if err != nil {
			delivery.NewResponser(c).Status(http.StatusUnauthorized).WithError(http.StatusText(http.StatusUnauthorized), err.Error()).Send()
			c.Abort()
			return
		}

		c.Set("user_id", claims.UserID)
		c.Next()

	}
}
