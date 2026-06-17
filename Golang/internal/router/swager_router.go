package router

import (
	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

func SetupSwaggerDocs(rg *gin.RouterGroup) {
	v1 := rg.Group("/api/v1")
	{
		v1.GET("/swagger/*any", func(c *gin.Context) {
			ginSwagger.WrapHandler(swaggerFiles.Handler)
		})
	}
}
