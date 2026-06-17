package repository

import (
	"context"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	e "github.com/MostafaSensei106/Astro-Wars/Golang/internal/errors"
	"gorm.io/gorm"
)

type runRepository struct {
	db *gorm.DB
}

func NewRunRepository(db *gorm.DB) domain.RunRepository {
	return &runRepository{db: db}
}

func (r *runRepository) Create(ctx context.Context, run *domain.Runs) e.Result[*domain.Runs, error] {
	return QueryExecutor(func() (*domain.Runs, error) {
		err := r.db.WithContext(ctx).Create(run).Error
		return run, err
	})
}

func (r *runRepository) FindByUserID(ctx context.Context, userID string) e.Result[[]domain.Runs, error] {
	return QueryExecutor(func() ([]domain.Runs, error) {
		var list []domain.Runs
		err := r.db.WithContext(ctx).Where("user_id = ?", userID).Order("created_at desc").Find(&list).Error
		return list, err
	})
}
