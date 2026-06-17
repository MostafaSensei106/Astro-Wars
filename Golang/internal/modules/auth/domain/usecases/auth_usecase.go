package usecases

import (
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/modules/auth/data/repositories"
)

type AuthUseCase struct {
	repo repositories.AuthRepository
}

func New(repo repositories.AuthRepository) *AuthUseCase {
	return &AuthUseCase{
		repo: repo,
	}
}
