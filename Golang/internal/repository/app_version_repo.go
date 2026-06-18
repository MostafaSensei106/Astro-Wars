package repository

import (
	"context"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	e "github.com/MostafaSensei106/Astro-Wars/Golang/internal/errors"
	"gorm.io/gorm"
)

type appVersionRepository struct {
	db *gorm.DB
}

func NewAppVersionRepository(db *gorm.DB) domain.AppVersionRepository {
	return &appVersionRepository{db: db}
}

func (r *appVersionRepository) Update(ctx context.Context, appVersion *domain.AppVersion) e.Result[*domain.AppVersion, error] {
	return QueryExecutor(func() (*domain.AppVersion, error) {
		err := r.db.WithContext(ctx).Save(appVersion).Error
		return appVersion, err
	})
}

func (r *appVersionRepository) Create(ctx context.Context, appVersion *domain.AppVersion) e.Result[*domain.AppVersion, error] {
	return QueryExecutor(func() (*domain.AppVersion, error) {
		err := r.db.WithContext(ctx).Create(appVersion).Error
		return appVersion, err
	})
}

func (r *appVersionRepository) Delete(ctx context.Context, id string) e.Result[bool, error] {
	return QueryExecutor(func() (bool, error) {
		var version domain.AppVersion
		err := r.db.WithContext(ctx).Delete(&version, "id = ?", id).Error
		return err == nil, err
	})
}
func (r *appVersionRepository) GetLatestVersion(ctx context.Context, platform string) e.Result[*domain.AppVersion, error] {
	return QueryExecutor(func() (*domain.AppVersion, error) {
		var version domain.AppVersion
		err := r.db.WithContext(ctx).Where("is_published = ?", true).Order("version_code desc").First(&version).Error
		return &version, err
	})
}
