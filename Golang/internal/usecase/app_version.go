package usecase

import (
	"context"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/errors"
)

type appVersionUseCase struct {
	repo domain.AppVersionRepository
}

func (a *appVersionUseCase) GetLatestVersion(ctx context.Context, platform string) errors.Result[*domain.AppVersion, error] {
	return a.repo.GetLatestVersion(ctx, platform)
}

func (a *appVersionUseCase) PublishVersion(ctx context.Context, appVersion *domain.AppVersion) errors.Result[*domain.AppVersion, error] {
	appVersion.IsPublished = true
	return a.repo.Update(ctx, appVersion)
}

func NewAppVersionUseCase(repo domain.AppVersionRepository) domain.AppVersionUseCase {
	return &appVersionUseCase{repo: repo}
}
