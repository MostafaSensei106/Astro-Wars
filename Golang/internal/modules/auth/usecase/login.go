package usecase

import (
	"context"
	"errors"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/modules/auth/domain"
)

func (uc *AuthUseCase) Login(ctx context.Context, email string, password string) (*domain.User, error) {
	user, err := uc.repo.FindByEmail(ctx, email)
	if err != nil {
		return nil, err
	}

	if user == nil {
		return nil, errors.New("user not found")
	}

	if user.PasswordHash != password {
		return nil, errors.New("invalid credentials")
	}

	return user, nil

}
