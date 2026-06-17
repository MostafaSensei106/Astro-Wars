# Build stage
FROM golang:1.26.3

# Set working directory
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the application code
COPY *.go ./


# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build


# Expose the port the app runs on//a
EXPOSE 8080

# Command to run the application
CMD ["./main"]