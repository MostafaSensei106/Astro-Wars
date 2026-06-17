package usecase

import (
	"context"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/modules/auth/domain"
)

type AuthUseCase struct {
	repo domain.AuthRepository
}

// Create implements [domain.AuthUseCase].
func (a *AuthUseCase) Create(ctx context.Context, user *domain.User) error {
	return a.repo.Create(ctx, user)
}

// FindByEmail implements [domain.AuthUseCase].
func (a *AuthUseCase) FindByEmail(ctx context.Context, email string) (*domain.User, error) {
	return a.repo.FindByEmail(ctx, email)
}
func New(repo domain.AuthRepository) domain.AuthUseCase {
	return &AuthUseCase{
		repo: repo,
	}
}
