package repository

import (
	"context"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/modules/auth/domain"
	"gorm.io/gorm"
)

type authRepository struct {
	db *gorm.DB
}

func New(db *gorm.DB) domain.AuthRepository {
	return &authRepository{
		db: db,
	}
}

func (a *authRepository) Create(ctx context.Context, user *domain.User) error {
	return a.db.WithContext(ctx).Create(user).Error
}

func (a *authRepository) FindByEmail(ctx context.Context, email string) (*domain.User, error) {
	var user domain.User
	if err := a.db.WithContext(ctx).Where("email = ?", email).First(&user).Error; err != nil {
		return nil, err
	}
	return &user, nil
}
