package error

// Failure is the interface that all domain errors must implement.
type Failure interface {
	Error() string
}

// BaseFailure is a basic implementation of the Failure interface.
type BaseFailure struct {
	Message string
}

func (b BaseFailure) Error() string {
	return b.Message
}
