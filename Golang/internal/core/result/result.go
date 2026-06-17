package result

// Result wraps a successful value of type T or an error of type E.
type Result[T any, E any] struct {
	data *T
	err  *E
}

// Success creates a successful Result.
func Success[T any, E any](data T) Result[T, E] {
	return Result[T, E]{data: &data}
}

// Failure creates a failed Result.
func Failure[T any, E any](err E) Result[T, E] {
	return Result[T, E]{err: &err}
}

// TryCatching executes the given action and wraps the result or error.
func TryCatching[T any, E any](action func() (T, error), onError func(error) E) Result[T, E] {
	data, err := action()
	if err != nil {
		return Failure[T](onError(err))
	}
	return Success[T, E](data)
}

// IsSuccess returns true if the Result is a success.
func (r Result[T, E]) IsSuccess() bool {
	return r.data != nil
}

// IsFailure returns true if the Result is a failure.
func (r Result[T, E]) IsFailure() bool {
	return r.err != nil
}

// DataOrNull returns a pointer to the data if successful, otherwise nil.
func (r Result[T, E]) DataOrNull() *T {
	return r.data
}

// ErrorOrNull returns a pointer to the error if failed, otherwise nil.
func (r Result[T, E]) ErrorOrNull() *E {
	return r.err
}

// When applies onSuccess if successful, otherwise onFailure.
func (r Result[T, E]) When(success func(T) any, failure func(E) any) any {
	if r.IsSuccess() {
		return success(*r.data)
	}
	return failure(*r.err)
}

// GetOrElse returns the data if successful, otherwise the result of fallback.
func (r Result[T, E]) GetOrElse(fallback func(E) T) T {
	if r.IsSuccess() {
		return *r.data
	}
	return fallback(*r.err)
}

// OnSuccess executes the action if the Result is a success.
func (r Result[T, E]) OnSuccess(action func(T)) Result[T, E] {
	if r.IsSuccess() {
		action(*r.data)
	}
	return r
}

// OnFailure executes the action if the Result is a failure.
func (r Result[T, E]) OnFailure(action func(E)) Result[T, E] {
	if r.IsFailure() {
		action(*r.err)
	}
	return r
}

// MapError maps the error of a failed Result to a new error type.
func MapError[T any, E any, NewError any](r Result[T, E], mapper func(E) NewError) Result[T, NewError] {
	if r.IsSuccess() {
		return Success[T, NewError](*r.data)
	}
	return Failure[T](mapper(*r.err))
}
