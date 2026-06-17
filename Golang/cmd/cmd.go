package cmd

import (
	"log"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/config"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/db"
	deliveryHttp "github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery/http"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/repository"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/usecase"
	"github.com/gin-gonic/gin"
)

func Execute() {
	// 1. Load config
	cfg := config.LoadConfig()

	// 2. Initialize Database
	database := db.NewPostgresDB(cfg)

	// 3. Initialize Repositories
	userRepo := repository.NewUserPgRepository(database)
	runRepo := repository.NewRunPgRepository(database)
	upgradeRepo := repository.NewUpgradePgRepository(database)

	// 4. Initialize UseCases
	authUC := usecase.NewAuthUseCase(userRepo, cfg.JWTSecret)
	runUC := usecase.NewRunUseCase(runRepo, userRepo)
	upgradeUC := usecase.NewUpgradeUseCase(upgradeRepo)

	// 5. Initialize Delivery (HTTP Handler)
	handler := deliveryHttp.NewHandler(authUC, runUC, upgradeUC, userRepo)

	// 6. Setup Gin Router
	router := gin.Default()
	
	// Register Routes
	deliveryHttp.RegisterRoutes(router, handler, authUC)

	// 7. Start Server
	log.Printf("Starting server on port %s", cfg.Port)
	if err := router.Run(":" + cfg.Port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
