package models

import (
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/modules/auth/domain/entities"
)

type UserStatsModele struct {
	Level      int `json:"level" gorm:"type:int; not null; default:1"`
	Experience int `json:"experience" gorm:"type:int;not null;default:0"`
	Coins      int `json:"coins" gorm:"type:int;not null;default:0"`
}

type UserModel struct {
	ID           string `gorm:"primaryKey"`
	Name         string `gorm:"type:varchar(255);not null"`
	Email        string `gorm:"uniqueIndex" json:"email" binding:"required,email"`
	Track        string `json:"track" binding:"required"`
	Grade        int    `json:"grade" binding:"required,min=1,max=5"`
	PasswordHash string
}

func (m *UserModel) ToEntity() *entities.User {
	if m == nil {
		return nil
	}
	return &entities.User{
		ID:           m.ID,
		Name:         m.Name,
		Email:        m.Email,
		PasswordHash: m.PasswordHash,
	}
}

func FromEntity(e *entities.User) *UserModel {
	if e == nil {
		return nil
	}
	return &UserModel{
		ID:           e.ID,
		Name:         e.Name,
		Email:        e.Email,
		PasswordHash: e.PasswordHash,
	}
}
