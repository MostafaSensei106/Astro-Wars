package domain

import (
	"time"

	"gorm.io/gorm"
)

type BaseEntity struct {
	ID        string         `json:"id" gorm:"type:uuid;default:gen_random_uuid();primaryKey"`
	CreatedAt time.Time      `json:"created_at" gorm:"autoCreateTime"`
	UpdatedAt time.Time      `json:"-" gorm:"autoUpdateTime"`
	DeletedAt gorm.DeletedAt `json:"-" swaggerignore:"true"`
}
