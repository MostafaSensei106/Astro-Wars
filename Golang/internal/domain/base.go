package domain

import (
	"time"

	"gorm.io/gorm"
)

type BaseEntity struct {
	ID        string         `gorm:"type:uuid;default:gen_random_uuid();primaryKey"`
	CreatedAt time.Time      `json:"created_at" gorm:"autoCreateTime"`
	UpdatedAt time.Time      `json:"updated_at" gorm:"autoUpdateTime"`
	DeletedAt gorm.DeletedAt `json:"deleted_at,omitempty" gorm:"index" `
}
