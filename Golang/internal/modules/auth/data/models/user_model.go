package models

import (
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/modules/auth/domain/entities"
)

type UserModel struct {
	ID           string `gorm:"primaryKey"`
	Name         string
	Email        string `gorm:"uniqueIndex"`
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
