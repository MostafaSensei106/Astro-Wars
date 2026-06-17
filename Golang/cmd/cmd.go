package cmd

import (
	"log"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery/http/handlers"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery/jwt"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/repository"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/router"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/usecase"
)

func Execute() {
	// 1. Load environment variables
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found, relying on environment variables")
	}

	// 2. Setup Database connection
	dsn := os.Getenv("DATABASE_URL")
	if dsn == "" {
		dsn = "host=localhost user=postgres password=postgres dbname=astrowars port=5432 sslmode=disable TimeZone=UTC" // Default dev DB
	}

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	// 3. Auto-migrate models
	err = db.AutoMigrate(&domain.User{})
	if err != nil {
		log.Fatalf("Failed to auto-migrate models: %v", err)
	}

	// 4. Dependency Injection Setup
	jwtSecret := os.Getenv("JWT_SECRET")
	if jwtSecret == "" {
		jwtSecret = "super-secret-key-change-me" // Default for local dev
	}
	
	// Initialize Services, Repositories, UseCases, and Handlers
	jwtSvc := jwt.NewJWTService(jwtSecret, "astrowars-backend")
	userRepo := repository.New(db)
	userUsecase := usecase.New(userRepo)
	authHandler := handlers.NewAuthHandler(userUsecase, jwtSvc)

	// 5. Setup Gin HTTP server
	r := gin.Default()

	// 6. Setup Routes
	router.SetupAuthRoutes(&r.RouterGroup, authHandler)

	// 7. Run Server
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	
	log.Printf("🚀 Starting Astro Wars server on port %s", port)
	if err := r.Run(":" + port); err != nil {
		log.Fatalf("Failed to run server: %v", err)
	}
}
