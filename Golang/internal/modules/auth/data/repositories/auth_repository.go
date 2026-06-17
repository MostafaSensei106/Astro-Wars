package repositories

import (
	"context"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/modules/auth/domain/entities"
)

type AuthRepository interface {
	Create(ctx context.Context, user *entities.User) error
	FindByEmail(ctx context.Context, email string) (*entities.User, error)
}
