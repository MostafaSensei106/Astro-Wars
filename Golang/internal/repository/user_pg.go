package repository

import (
	"errors"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	"gorm.io/gorm"
)

type userPgRepository struct {
	db *gorm.DB
}

func NewUserPgRepository(db *gorm.DB) domain.UserRepository {
	return &userPgRepository{db: db}
}

func (r *userPgRepository) Create(user *domain.User) error {
	return r.db.Create(user).Error
}

func (r *userPgRepository) GetByID(id uint) (*domain.User, error) {
	var user domain.User
	if err := r.db.First(&user, id).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil // or return custom domain error
		}
		return nil, err
	}
	return &user, nil
}

func (r *userPgRepository) GetByUsername(username string) (*domain.User, error) {
	var user domain.User
	if err := r.db.Where("username = ?", username).First(&user).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &user, nil
}

func (r *userPgRepository) UpdateTotalCommits(id uint, additionalCommits int64) error {
	return r.db.Model(&domain.User{}).Where("id = ?", id).
		UpdateColumn("total_commits", gorm.Expr("total_commits + ?", additionalCommits)).Error
}

func (r *userPgRepository) GetTopPlayers(limit int) ([]domain.User, error) {
	var users []domain.User
	if err := r.db.Order("total_commits desc").Limit(limit).Find(&users).Error; err != nil {
		return nil, err
	}
	return users, nil
}
