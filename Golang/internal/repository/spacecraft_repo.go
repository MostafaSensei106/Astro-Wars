package repository

import (
	"context"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	e "github.com/MostafaSensei106/Astro-Wars/Golang/internal/errors"
	"gorm.io/gorm"
)

type spacecraftRepository struct {
	db *gorm.DB
}

func NewSpacecraftRepository(db *gorm.DB) domain.SpacecraftRepository {
	return &spacecraftRepository{db: db}
}

func (r *spacecraftRepository) Create(ctx context.Context, s *domain.Spacecraft) e.Result[*domain.Spacecraft, error] {
	return QueryExecutor(func() (*domain.Spacecraft, error) {
		err := r.db.WithContext(ctx).Create(s).Error
		return s, err
	})
}

func (r *spacecraftRepository) FindByUserID(ctx context.Context, userID string) e.Result[[]domain.Spacecraft, error] {
	return QueryExecutor(func() ([]domain.Spacecraft, error) {
		var list []domain.Spacecraft
		err := r.db.WithContext(ctx).Where("user_id = ?", userID).Find(&list).Error
		return list, err
	})
}

func (r *spacecraftRepository) FindByID(ctx context.Context, id string) e.Result[*domain.Spacecraft, error] {
	return QueryExecutor(func() (*domain.Spacecraft, error) {
		var s domain.Spacecraft
		err := r.db.WithContext(ctx).Where("id = ?", id).First(&s).Error
		return &s, err
	})
}

func (r *spacecraftRepository) Update(ctx context.Context, s *domain.Spacecraft) e.Result[*domain.Spacecraft, error] {
	return QueryExecutor(func() (*domain.Spacecraft, error) {
		err := r.db.WithContext(ctx).Save(s).Error
		return s, err
	})
}
