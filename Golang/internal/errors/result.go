package errors

// Result represents a value that is either a success or a failure.
type Result[T any, E any] struct {
	data      T
	error     E
	isSuccess bool
}

// Success creates a successful Result.
func Success[T any, E any](data T) Result[T, E] {
	return Result[T, E]{
		data:      data,
		isSuccess: true,
	}
}

// Failure creates a failed Result.
func Failure[T any, E any](err E) Result[T, E] {
	return Result[T, E]{
		error:     err,
		isSuccess: false,
	}
}

// TryCatching wraps a function returning (T, error) into a Result[T, E].
func TryCatching[T any, E any](action func() (T, error), onError func(error) E) Result[T, E] {
	data, err := action()
	if err != nil {
		return Failure[T, E](onError(err))
	}
	return Success[T, E](data)
}

// IsSuccess returns true if the Result is a success.
func (r Result[T, E]) IsSuccess() bool {
	return r.isSuccess
}

// IsFailure returns true if the Result is a failure.
func (r Result[T, E]) IsFailure() bool {
	return !r.isSuccess
}

// DataOrNull returns a pointer to the data if success, otherwise nil.
func (r Result[T, E]) DataOrNull() *T {
	if r.isSuccess {
		return &r.data
	}
	return nil
}

// ErrorOrNull returns a pointer to the error if failure, otherwise nil.
func (r Result[T, E]) ErrorOrNull() *E {
	if !r.isSuccess {
		return &r.error
	}
	return nil
}

// GetOrElse returns the data if success, or the result of the fallback function if failure.
func (r Result[T, E]) GetOrElse(fallback func(E) T) T {
	if r.isSuccess {
		return r.data
	}
	return fallback(r.error)
}

// OnSuccess executes the action if the Result is a success.
func (r Result[T, E]) OnSuccess(action func(T)) Result[T, E] {
	if r.isSuccess {
		action(r.data)
	}
	return r
}

// OnFailure executes the action if the Result is a failure.
func (r Result[T, E]) OnFailure(action func(E)) Result[T, E] {
	if !r.isSuccess {
		action(r.error)
	}
	return r
}

// Fold applies onSuccess or onFailure based on the result.
func Fold[T any, E any, R any](r Result[T, E], onSuccess func(T) R, onFailure func(E) R) R {
	if r.isSuccess {
		return onSuccess(r.data)
	}
	return onFailure(r.error)
}

// MapError maps the error type to a new error type.
func MapError[T any, E any, NewError any](r Result[T, E], mapper func(E) NewError) Result[T, NewError] {
	if r.isSuccess {
		return Success[T, NewError](r.data)
	}
	return Failure[T, NewError](mapper(r.error))
}
