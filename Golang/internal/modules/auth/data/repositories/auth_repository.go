package repositories

import (
	"context"

	coreError "github.com/MostafaSensei106/Astro-Wars/Golang/internal/core/error"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/core/result"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/modules/auth/domain/entities"
)

type AuthRepository interface {
	Create(ctx context.Context, user *entities.User) result.Result[*entities.User, coreError.Failure]
	FindByEmail(ctx context.Context, email string) result.Result[*entities.User, coreError.Failure]
}
