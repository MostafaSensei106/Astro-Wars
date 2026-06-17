package usecase

import (
	"context"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/core/error"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/core/result"
)

// BaseUseCase represents the contract that all use cases must implement.
type BaseUseCase[T any, Params any] interface {
	Call(ctx context.Context, params Params) result.Result[T, error.Failure]
}

// NoParams is used for use cases that do not require any parameters.
type NoParams struct{}
