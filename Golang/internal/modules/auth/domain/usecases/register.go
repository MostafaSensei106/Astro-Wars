package usecases

import (
	"context"

	coreError "github.com/MostafaSensei106/Astro-Wars/Golang/internal/core/error"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/core/result"
	coreUsecase "github.com/MostafaSensei106/Astro-Wars/Golang/internal/core/usecase"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/modules/auth/data/repositories"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/modules/auth/domain/entities"
	"golang.org/x/crypto/bcrypt"
)

type RegisterUseCase struct {
	repo repositories.AuthRepository
}

func NewRegisterUseCase(repo repositories.AuthRepository) *RegisterUseCase {
	return &RegisterUseCase{repo: repo}
}

func (uc *RegisterUseCase) Call(ctx context.Context, user *entities.User) result.Result[*entities.User, coreError.Failure] {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
	if err != nil {
		return result.Failure[*entities.User, coreError.Failure](coreError.BaseFailure{Message: err.Error()})
	}

	user.PasswordHash = string(hashedPassword)
	// Clear the plain text password after hashing for security
	user.Password = ""

	return uc.repo.Create(ctx, user)
}

var _ coreUsecase.BaseUseCase[*entities.User, *entities.User] = (*RegisterUseCase)(nil)
