package repositories

import (
	"context"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/modules/auth/data/models"
	dataRepo "github.com/MostafaSensei106/Astro-Wars/Golang/internal/modules/auth/data/repositories"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/modules/auth/domain/entities"
	"gorm.io/gorm"
)

type authRepository struct {
	db *gorm.DB
}

func New(db *gorm.DB) dataRepo.AuthRepository {
	return &authRepository{
		db: db,
	}
}

func (a *authRepository) Create(ctx context.Context, user *entities.User) error {
	userModel := models.FromEntity(user)
	return a.db.WithContext(ctx).Create(userModel).Error
}

func (a *authRepository) FindByEmail(ctx context.Context, email string) (*entities.User, error) {
	var userModel models.UserModel
	if err := a.db.WithContext(ctx).Where("email = ?", email).First(&userModel).Error; err != nil {
		return nil, err
	}
	return userModel.ToEntity(), nil
}
