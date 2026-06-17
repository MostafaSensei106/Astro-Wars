package router

import (
	_ "github.com/MostafaSensei106/Astro-Wars/Golang/docs"
	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

func SetupSwaggerDocs(rg *gin.RouterGroup) {
	v1 := rg.Group("/api/v1")
	{
		v1.GET(
			"/swagger/*any",
			ginSwagger.WrapHandler(swaggerFiles.Handler),
		)
	}
}
