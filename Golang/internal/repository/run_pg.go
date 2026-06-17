package repository

import (
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	"gorm.io/gorm"
)

type runPgRepository struct {
	db *gorm.DB
}

func NewRunPgRepository(db *gorm.DB) domain.RunRepository {
	return &runPgRepository{db: db}
}

func (r *runPgRepository) Create(run *domain.Run) error {
	return r.db.Create(run).Error
}

func (r *runPgRepository) GetRunsByUserID(userID uint, limit int) ([]domain.Run, error) {
	var runs []domain.Run
	err := r.db.Where("user_id = ?", userID).Order("created_at desc").Limit(limit).Find(&runs).Error
	if err != nil {
		return nil, err
	}
	return runs, nil
}
