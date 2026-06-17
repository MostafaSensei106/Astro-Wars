package middleware

import (
	"net/http"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery"
	"github.com/gin-gonic/gin"
)

// ErrorHandler is a middleware that intercepts all errors and standardizes the error response format.
func ErrorHandler() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Next()

		if len(c.Errors) > 0 {
			err := c.Errors.Last()

			status := c.Writer.Status()

			// Ensure we send a well-formatted standard response
			if !c.Writer.Written() {
				delivery.NewResponser(c).
					Status(status).
					WithError(http.StatusText(status), err.Error()).
					Send()
			}
		}
	}
}

// PanicRecovery is a middleware that catches panics and translates them into a standard JSON error response.
func PanicRecovery() gin.HandlerFunc {
	return func(c *gin.Context) {
		defer func() {
			if err := recover(); err != nil {
				var errMsg string
				switch e := err.(type) {
				case error:
					errMsg = e.Error()
				case string:
					errMsg = e
				default:
					errMsg = "An unexpected error occurred"
				}

				if !c.Writer.Written() {
					delivery.NewResponser(c).
						Status(http.StatusInternalServerError).
						WithError(http.StatusText(http.StatusInternalServerError), errMsg).
						Send()
				}
				c.Abort()
			}
		}()
		c.Next()
	}
}
