package repository

import (
	"errors"

	"github.com/jackc/pgx/v5/pgconn"
	"gorm.io/gorm"

	errs "github.com/MostafaSensei106/Astro-Wars/Golang/internal/errors"
)

// DBErrorHandler handles mapping of database errors to domain errors.
type DBErrorHandler struct{}

// Handle processes the error and returns a mapped error.
func (h DBErrorHandler) Handle(err error) error {
	if err == nil {
		return nil
	}

	// 1. Handle GORM RecordNotFound
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return errs.ErrNotFound
	}

	// 2. Handle PostgreSQL specific errors (e.g. Unique Violation)
	var pgErr *pgconn.PgError
	if errors.As(err, &pgErr) {
		switch pgErr.Code {
		case "23505": // unique_violation
			return errs.ErrConflict
		}
	}

	// 3. Fallback raw error
	return err
}

var dbErrorHandler = DBErrorHandler{}

// QueryExecutor wraps database operations and catches errors using Result.tryCatching.
func QueryExecutor[T any](action func() (T, error)) errs.Result[T, error] {
	return errs.TryCatching(
		action,
		func(err error) error {
			return dbErrorHandler.Handle(err)
		},
	)
}
