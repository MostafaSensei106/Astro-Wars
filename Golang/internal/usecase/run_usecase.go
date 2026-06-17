package usecase

import (
	"context"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	e "github.com/MostafaSensei106/Astro-Wars/Golang/internal/errors"
)

type runUseCase struct {
	repo domain.RunRepository
}

func NewRunUseCase(repo domain.RunRepository) domain.RunUseCase {
	return &runUseCase{repo: repo}
}

func (uc *runUseCase) SaveRun(ctx context.Context, run *domain.Runs) e.Result[*domain.Runs, error] {
	return uc.repo.Create(ctx, run)
}

func (uc *runUseCase) GetUserRuns(ctx context.Context, userID string) e.Result[[]domain.Runs, error] {
	return uc.repo.FindByUserID(ctx, userID)
}
