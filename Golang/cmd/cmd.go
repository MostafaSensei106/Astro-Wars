package cmd

import (
	"log"
	"log/slog"
	"os"

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

	logger := slog.New(slog.NewTextHandler(os.Stdout, nil))
	slog.SetDefault(logger)

	cfg := config{
		port: ":8080",
		db: dbConfig{
			dns: env.GetString("CHOCHO_DB_DSN", "host=localhost user=root password=root dbname=chocho sslmode=disable"),
		},
	}

	db := db.ConnectPostgres(cfg.db.dns)

	jwtSvc := jwt.NewJWTService(env.GetString("CHOCHO_JWT_SECRET", "defaultsecretkey"), "astrowars-backend")
	userRepo := repository.New(db)
	userUsecase := usecase.New(userRepo)
	authHandler := handlers.NewAuthHandler(userUsecase, jwtSvc)

	r := gin.Default()

	router.SetupAuthRoutes(&r.RouterGroup, authHandler)

	log.Printf("🚀 Starting Astro Wars server on port %s", cfg.port)
	if err := r.Run(":" + cfg.port); err != nil {
		log.Fatalf("Failed to run server: %v", err)
	}
}
