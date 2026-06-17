package usecases

import (
	"context"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/modules/auth/domain/entities"
	"golang.org/x/crypto/bcrypt"
)

func (uc *AuthUseCase) Register(ctx context.Context, name, email, password string) error {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}

	return uc.repo.Create(ctx, &entities.User{
		Name:         name,
		Email:        email,
		PasswordHash: string(hashedPassword),
	})
}
