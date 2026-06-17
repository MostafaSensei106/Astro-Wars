package repositories

import (
	"context"

	coreError "github.com/MostafaSensei106/Astro-Wars/Golang/internal/core/error"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/core/result"
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

func (a *authRepository) Create(ctx context.Context, user *entities.User) result.Result[*entities.User, coreError.Failure] {
	userModel := models.FromEntity(user)
	if err := a.db.WithContext(ctx).Create(userModel).Error; err != nil {
		return result.Failure[*entities.User, coreError.Failure](coreError.BaseFailure{Message: err.Error()})
	}
	return result.Success[*entities.User, coreError.Failure](userModel.ToEntity())
}

func (a *authRepository) FindByEmail(ctx context.Context, email string) result.Result[*entities.User, coreError.Failure] {
	var userModel models.UserModel
	if err := a.db.WithContext(ctx).Where("email = ?", email).First(&userModel).Error; err != nil {
		return result.Failure[*entities.User, coreError.Failure](coreError.BaseFailure{Message: err.Error()})
	}
	return result.Success[*entities.User, coreError.Failure](userModel.ToEntity())
}
