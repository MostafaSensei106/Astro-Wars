package repository

import (
	"context"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	e "github.com/MostafaSensei106/Astro-Wars/Golang/internal/errors"
	"gorm.io/gorm"
)

type userRepository struct {
	db *gorm.DB
}

// Create implements [domain.UserRepository].
func (u *userRepository) Create(ctx context.Context, user *domain.User) e.Result[*domain.User, error] {
	return QueryExecutor(func() (*domain.User, error) {
		err := u.db.WithContext(ctx).Create(user).Error
		return user, err
	})
}

// Delete implements [domain.UserRepository].
func (u *userRepository) Delete(ctx context.Context, id string) e.Result[bool, error] {
	return QueryExecutor(func() (bool, error) {
		var user domain.User
		err := u.db.WithContext(ctx).Delete(&user, "id = ?", id).Error
		return err == nil, err
	})
}

// FindByUsername implements [domain.UserRepository].
func (u *userRepository) FindByUsername(ctx context.Context, username string) e.Result[*domain.User, error] {
	return QueryExecutor(func() (*domain.User, error) {
		var user domain.User
		err := u.db.WithContext(ctx).First(&user, "username = ?", username).Error
		return &user, err
	})
}

// FindByID implements [domain.UserRepository].
func (u *userRepository) FindByID(ctx context.Context, id string) e.Result[*domain.User, error] {
	return QueryExecutor(func() (*domain.User, error) {
		var user domain.User
		err := u.db.WithContext(ctx).First(&user, "id = ?", id).Error
		return &user, err
	})
}

// Update implements [domain.UserRepository].
func (u *userRepository) Update(ctx context.Context, user *domain.User) e.Result[*domain.User, error] {
	return QueryExecutor(func() (*domain.User, error) {
		err := u.db.WithContext(ctx).Save(user).Error
		return user, err
	})
}

func NewUserRepository(db *gorm.DB) domain.UserRepository {
	return &userRepository{db}
}
