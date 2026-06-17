package base

import (
	"time"

	"gorm.io/gorm"
)

type BaseEntity struct {
	ID        string         `json:"id" gorm:"primaryKey;type:uuid;default:uuid_generate_v4()"`
	CreatedAt time.Time      `json:"created_at" gorm:"autoCreateTime"`
	UpdatedAt time.Time      `json:"updated_at" gorm:"autoUpdateTime"`
	DeletedAt gorm.DeletedAt `json:"deleted_at,omitempty" gorm:"index" `
}

type NoParams struct {
}
type BaseUseCase[Type any, Params any] interface {
	Call(params Params) (Type, error)
}
