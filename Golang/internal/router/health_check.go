package router

import (
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery"
	"github.com/gin-gonic/gin"
)

func SetupHelthCheck(rg *gin.RouterGroup) {
	v1 := rg.Group("/api/v1")
	{
		v1.GET("/health", func(c *gin.Context) {
			delivery.NewResponser(c).WithData("Good").Send()
		})
	}
}
