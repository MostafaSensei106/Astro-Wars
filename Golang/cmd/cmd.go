package cmd

import (
	"log"

	"github.com/gin-gonic/gin"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery/http/handlers"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery/jwt"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/env"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/infrastructure/db"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/repository"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/router"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/usecase"
)

func Execute() {
	cfg := config{
		port: ":8080",
		db: dbConfig{
			dns: env.GetString("ASWTRO_WARS_DB_DSN", "host=localhost user=root password=root dbname=astro sslmode=disable"),
		},
	}

	db := db.ConnectPostgres(cfg.db.dns)

	jwtSvc := jwt.NewJWTService(env.GetString("CHOCHO_JWT_SECRET", "defaultsecretkey"), "astrowars-backend")

	userRepo := repository.NewUserRepository(db)
	runRepo := repository.NewRunRepository(db)
	userUsecase := usecase.NewUserRepository(userRepo)
	appVersionRepo := repository.NewAppVersionRepository(db)
	appVersionUsecase := usecase.NewAppVersionUseCase(appVersionRepo)
	runUsecase := usecase.NewRunUseCase(runRepo)
	authHandler := handlers.NewAuthHandler(userUsecase, jwtSvc)
	profileHandler := handlers.NewProfileHandler(userUsecase, jwtSvc)
	runHandler := handlers.NewRunHandler(runUsecase)
	appVersionHandler := handlers.NewAppVersionHandler(appVersionUsecase)

	r := gin.Default()
	gin.SetMode(gin.ReleaseMode)

	router.SetupHelthCheckRoutes(&r.RouterGroup)
	router.SetupSwaggerDocsRoutes(&r.RouterGroup)
	router.SetupAuthRoutes(&r.RouterGroup, authHandler, jwtSvc)
	router.SetupProfileRoutes(&r.RouterGroup, profileHandler, jwtSvc)
	router.SetupRunRoutes(&r.RouterGroup, runHandler, jwtSvc)
	router.SetupAppVersionRoutes(&r.RouterGroup, appVersionHandler, jwtSvc)

	log.Printf("🚀 Starting Astro Wars server on port %s", cfg.port)
	if err := r.Run(cfg.port); err != nil {
		log.Fatalf("Failed to run server: %v", err)
	}
}
