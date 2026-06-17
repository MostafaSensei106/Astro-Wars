package domain

import (
	"time"

	"github.com/golang-jwt/jwt/v5"
)

type User struct {
	ID           uint      `json:"id" gorm:"primaryKey"`
	Username     string    `json:"username" gorm:"uniqueIndex;not null"`
	PasswordHash string    `json:"-" gorm:"not null"` // Excluded from JSON responses
	TotalCommits int64     `json:"total_commits" gorm:"default:0;index"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`

	// Relationships
	Runs     []Run     `json:"runs,omitempty" gorm:"foreignKey:UserID"`
	Upgrades []Upgrade `json:"upgrades,omitempty" gorm:"foreignKey:UserID"`
}

type AuthTokenClaims struct {
	UserID   uint   `json:"user_id"`
	Username string `json:"username"`
	jwt.RegisteredClaims
}

type UserRepository interface {
	Create(user *User) error
	GetByID(id uint) (*User, error)
	GetByUsername(username string) (*User, error)
	UpdateTotalCommits(id uint, additionalCommits int64) error
	GetTopPlayers(limit int) ([]User, error)
}

type AuthUseCase interface {
	Register(username, password string) (*User, string, error)
	Login(username, password string) (string, error)
	ValidateToken(token string) (*AuthTokenClaims, error)
}
