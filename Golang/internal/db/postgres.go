package db

import (
	"log"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/config"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func NewPostgresDB(cfg *config.Config) *gorm.DB {
	db, err := gorm.Open(postgres.Open(cfg.DatabaseURL), &gorm.Config{})
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	// Run auto migrations
	err = db.AutoMigrate(&domain.User{}, &domain.Run{}, &domain.Upgrade{})
	if err != nil {
		log.Fatalf("Failed to run database migrations: %v", err)
	}

	log.Println("Database connection established and migrations run")
	return db
}
