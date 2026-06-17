package usecase

import (
	"context"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/errors"
)

type userUseCase struct {
	repo domain.UserRepository
}

// CreateUser implements [domain.UserUseCase].
func (u *userUseCase) CreateUser(ctx context.Context, user *domain.User) errors.Result[*domain.User, error] {
	return u.repo.Create(ctx, user)
}

// DeleteUser implements [domain.UserUseCase].
func (u *userUseCase) DeleteUser(ctx context.Context, id string) errors.Result[bool, error] {
	return u.repo.Delete(ctx, id)
}

// FindByUsername implements [domain.UserUseCase].
func (u *userUseCase) FindByUsername(ctx context.Context, username string) errors.Result[*domain.User, error] {
	return u.repo.FindByUsername(ctx, username)
}

// UpdateUser implements [domain.UserUseCase].
func (u *userUseCase) UpdateUser(ctx context.Context, user *domain.User) errors.Result[*domain.User, error] {
	return u.repo.Update(ctx, user)
}

func New(repo domain.UserRepository) domain.UserUseCase {
	return &userUseCase{repo: repo}
}
