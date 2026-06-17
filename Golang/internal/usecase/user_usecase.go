package usecase

import (
	"context"
	"fmt"
	"time"

	"golang.org/x/crypto/bcrypt"

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

func (u *userUseCase) Login(ctx context.Context, username, password string) errors.Result[*domain.User, error] {
	strategy := &domain.LoginStrategy{
		Username: username,
		Password: password,
		HashFunc: func(p, hash string) bool {
			return bcrypt.CompareHashAndPassword([]byte(hash), []byte(p)) == nil
		},
	}
	authCtx := domain.NewAuthContext(strategy)
	return authCtx.Authenticate(ctx, u.repo)
}

func (u *userUseCase) Register(ctx context.Context, user *domain.User, password string) errors.Result[*domain.User, error] {
	strategy := &domain.RegisterStrategy{
		User:     user,
		Password: password,
		HashFunc: func(p string) (string, error) {
			hash, err := bcrypt.GenerateFromPassword([]byte(p), bcrypt.DefaultCost)
			return string(hash), err
		},
	}
	authCtx := domain.NewAuthContext(strategy)
	return authCtx.Authenticate(ctx, u.repo)
}

func (u *userUseCase) GuestLogin(ctx context.Context) errors.Result[*domain.User, error] {
	strategy := &domain.GuestLoginStrategy{
		GenerateGuestID: func() string {
			return fmt.Sprintf("guest_%d", time.Now().UnixNano())
		},
	}
	authCtx := domain.NewAuthContext(strategy)
	return authCtx.Authenticate(ctx, u.repo)
}

func New(repo domain.UserRepository) domain.UserUseCase {
	return &userUseCase{repo: repo}
}
