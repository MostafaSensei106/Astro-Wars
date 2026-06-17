package db

import (
	"log"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func ConnectPostgres(dsn string) *gorm.DB {
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{
		SkipDefaultTransaction: true,
	})
	if err != nil {
		log.Fatalf("failed to connect to database: %v", err)
	}
	err = db.AutoMigrate(&domain.User{})
	if err != nil {
		log.Fatalf("failed to migrate database: %v", err)
	}
	log.Default().Println("Connected to PostgreSQL database successfully")

	return db
}
