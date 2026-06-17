package delivery

type Context interface {
	JSON(code int, data any)
}

type ErrorInfo struct {
	ErrorCode string `json:"error_code"`
	Message   string `json:"message"`
}

type Meta struct {
	Page         int  `json:"page"`
	PerPage      int  `json:"per_page"`
	Total        int  `json:"total"`
	LastPage     int  `json:"last_page"`
	NextPage     *int `json:"next_page"`
	PreviousPage *int `json:"previous_page"`
}

type Response struct {
}
