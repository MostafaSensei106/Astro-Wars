package usecases

import (
	"context"

	coreError "github.com/MostafaSensei106/Astro-Wars/Golang/internal/core/error"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/core/result"
	coreUsecase "github.com/MostafaSensei106/Astro-Wars/Golang/internal/core/usecase"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/modules/auth/data/repositories"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/modules/auth/domain/entities"
)

type LoginParams struct {
	Email    string
	Password string
}

type LoginUseCase struct {
	repo repositories.AuthRepository
}

func NewLoginUseCase(repo repositories.AuthRepository) *LoginUseCase {
	return &LoginUseCase{repo: repo}
}

func (uc *LoginUseCase) Call(ctx context.Context, params LoginParams) result.Result[*entities.User, coreError.Failure] {
	res := uc.repo.FindByEmail(ctx, params.Email)
	
	if res.IsFailure() {
		return res
	}

	user := res.DataOrNull()
	if user == nil || *user == nil {
		return result.Failure[*entities.User, coreError.Failure](coreError.BaseFailure{Message: "user not found"})
	}

	if (*user).PasswordHash != params.Password { // Assuming simple equality for now, normally bcrypt.CompareHashAndPassword
		return result.Failure[*entities.User, coreError.Failure](coreError.BaseFailure{Message: "invalid credentials"})
	}

	return result.Success[*entities.User, coreError.Failure](*user)
}

var _ coreUsecase.BaseUseCase[*entities.User, LoginParams] = (*LoginUseCase)(nil)
