package errors

import "errors"

var (
	ErrNotFound            = errors.New("resource not found")
	ErrConflict            = errors.New("resource already exists (conflict)")
	ErrInternalServerError = errors.New("internal server error")
	ErrBadRequest          = errors.New("bad request")
	ErrUnauthorized        = errors.New("unauthorized")
	ErrForbidden           = errors.New("forbidden")
)
