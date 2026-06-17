package delivery

import "net/http"

type Context interface {
	JSON(code int, data any)
}

type ErrorInfo struct {
	Code    string `json:"code"`
	Message string `json:"message"`
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
	Success bool       `json:"success"`
	Data    any        `json:"data,omitempty"`
	Error   *ErrorInfo `json:"error,omitempty"`
	Meta    *Meta      `json:"meta,omitempty"`
}

type Responser struct {
	ctx        Context
	statusCode int
	response   Response
}

func NewResponser(ctx Context) *Responser {
	return &Responser{
		ctx:        ctx,
		statusCode: http.StatusOK,
		response: Response{
			Success: true,
		},
	}
}

func (r *Responser) Status(code int) *Responser {
	r.statusCode = code
	return r
}

func (r *Responser) WithData(data any) *Responser {
	r.response.Data = data
	return r
}

func (r *Responser) WithMeta(meta *Meta) *Responser {
	r.response.Meta = meta
	return r
}

func (r *Responser) WithError(code string, message string) *Responser {
	r.response.Success = false
	r.response.Error = &ErrorInfo{
		Code:    code,
		Message: message,
	}
	return r
}

func (r *Responser) Send() {
	r.ctx.JSON(r.statusCode, r.response)
}
