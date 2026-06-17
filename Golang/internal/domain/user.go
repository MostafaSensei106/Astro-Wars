package domain

import (
	"context"
	"errors"
	"math"
	"time"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/constants"
	e "github.com/MostafaSensei106/Astro-Wars/Golang/internal/errors"
)

var ErrInvalidCredentials = errors.New("invalid credentials")

type User struct {
	BaseEntity
	Fullname     string    `json:"fullname" gorm:"type:varchar(100);not null"`
	Username     string    `json:"username" gorm:"type:varchar(50);uniqueIndex;not null"`
	PasswordHash string    `json:"-" gorm:"type:varchar(255);not null"`
	Stats        UserStats `json:"stats"    gorm:"embedded"`
	GdgInfo      GDGInfo   `json:"info" gorm:"embedded"`
}

type GDGInfo struct {
	College       string  `json:"college" gorm:"type:varchar(100);not null"`
	Department    string  `json:"department" gorm:"type:varchar(100):not null"`
	AcademicYear  int     `json:"academic_year" gorm:"type:int;default:1;check:academic_year >= 1 AND academic_year <= 5"`
	GdgTrack      *string `json:"gdg_track" gorm:"type:varchar(50):"`
	SystemRole    string  `json:"system_role" gorm:"type:varchar(20);default:player;not null"`
	CommunityRole string  `json:"community_role" gorm:"type:varchar(50);default:member:not null"` // core team - head - vice head -  facilitator - lead - co - lead - member
}

type UserStats struct {
	Level         int       `json:"level"          gorm:"type:int;not null;default:1"`
	Experience    int       `json:"experience"     gorm:"type:int;not null;default:0"`
	Coins         int       `json:"coins"          gorm:"type:int;not null;default:0"`
	Points        int       `json:"points"         gorm:"type:int;not null;default:0"`
	CurrentStreak int       `json:"current_streak" gorm:"type:int;not null;default:0"`
	MaxStreak     int       `json:"max_streak"     gorm:"type:int;not null;default:0"`
	LastPlayedAt  time.Time `json:"last_played_at" gorm:"type:timestamp;default:null"`
}

type AuthStrategy interface {
	Execute(ctx context.Context, repo UserRepository) e.Result[*User, error]
}

type UserRepository interface {
	Create(ctx context.Context, user *User) e.Result[*User, error]
	FindByUsername(ctx context.Context, username string) e.Result[*User, error]
	Update(ctx context.Context, user *User) e.Result[*User, error]
	Delete(ctx context.Context, id string) e.Result[bool, error]
}

type UserUseCase interface {
	FindByUsername(ctx context.Context, username string) e.Result[*User, error]
	CreateUser(ctx context.Context, user *User) e.Result[*User, error]
	UpdateUser(ctx context.Context, user *User) e.Result[*User, error]
	DeleteUser(ctx context.Context, id string) e.Result[bool, error]
	Login(ctx context.Context, username, password string) e.Result[*User, error]
	Register(ctx context.Context, user *User, password string) e.Result[*User, error]
	GuestLogin(ctx context.Context) e.Result[*User, error]
}

func (u *User) TrackActivity() {
	now := time.Now()
	if u.Stats.LastPlayedAt.IsZero() {
		u.Stats.CurrentStreak = 1
		u.Stats.MaxStreak = 1
		u.Stats.LastPlayedAt = now
		return
	}

	hoursSinceLastPlay := now.Sub(u.Stats.LastPlayedAt).Hours()
	if hoursSinceLastPlay <= 24 {
		if now.Day() != u.Stats.LastPlayedAt.Day() {
			u.Stats.CurrentStreak++
		}
	} else if hoursSinceLastPlay > 24 && hoursSinceLastPlay <= 48 {
		u.Stats.CurrentStreak++
	} else {
		u.Stats.CurrentStreak = 1
	}

	if u.Stats.CurrentStreak > u.Stats.MaxStreak {
		u.Stats.MaxStreak = u.Stats.CurrentStreak
	}
	u.Stats.LastPlayedAt = now
}

func (u *User) GetStreakMultiplier() float64 {
	if u.Stats.CurrentStreak <= 1 {
		return 1.0
	}
	/// Each day in the streak increases the multiplier by 5%, up to a maximum of 100% (2.0x)
	multiplier := 1.0 + (float64(u.Stats.CurrentStreak) * constants.StreakMultiplierPercent)
	if multiplier > constants.MaxStreakMultiplier {
		return constants.MaxStreakMultiplier
	}
	return multiplier
}

func (u *User) AddExperience(points int) bool {
	if points <= 0 {
		return false
	}

	finalAmount := int(float64(points) * u.GetStreakMultiplier())
	u.Stats.Experience += finalAmount

	leveledUp := false
	for u.Stats.Experience >= u.XPToNextLevel() {
		u.Stats.Experience -= u.XPToNextLevel()
		u.Stats.Level++
		u.Stats.Coins += u.Stats.Level * 10
		leveledUp = true
	}

	return leveledUp
}

func (u *User) XPToNextLevel() int {
	return int(100 * math.Pow(float64(u.Stats.Level), 1.5))
}

func (u *User) AddCoins(coins int) {
	if coins > 0 {
		u.Stats.Coins += coins
	}
}

// LoginStrategy implements AuthStrategy for normal login
type LoginStrategy struct {
	Username string
	Password string
	HashFunc func(password, hash string) bool
}

func (s *LoginStrategy) Execute(ctx context.Context, repo UserRepository) e.Result[*User, error] {
	result := repo.FindByUsername(ctx, s.Username)
	if result.IsFailure() {
		return result
	}
	user := *result.DataOrNull()
	if !s.HashFunc(s.Password, user.PasswordHash) {
		return e.Failure[*User, error](ErrInvalidCredentials)
	}
	return e.Success[*User, error](user)
}

// RegisterStrategy implements AuthStrategy for user registration
type RegisterStrategy struct {
	User     *User
	Password string
	HashFunc func(password string) (string, error)
}

func (s *RegisterStrategy) Execute(ctx context.Context, repo UserRepository) e.Result[*User, error] {
	hash, err := s.HashFunc(s.Password)
	if err != nil {
		return e.Failure[*User, error](err)
	}
	s.User.PasswordHash = hash
	createResult := repo.Create(ctx, s.User)
	if createResult.IsFailure() {
		return createResult
	}
	return e.Success[*User, error](s.User)
}

// GuestLoginStrategy implements AuthStrategy for guest login
type GuestLoginStrategy struct {
	GenerateGuestID func() string
}

func (s *GuestLoginStrategy) Execute(ctx context.Context, repo UserRepository) e.Result[*User, error] {
	guestUser := &User{
		Username:     s.GenerateGuestID(),
		Fullname:     "Guest",
		PasswordHash: "", // Guests do not need a password
		GdgInfo: GDGInfo{
			SystemRole:    "guest",
			CommunityRole: "none",
		},
	}
	createResult := repo.Create(ctx, guestUser)
	if createResult.IsFailure() {
		return createResult
	}
	return e.Success[*User, error](guestUser)
}

// AuthContext acts as the Strategy Context
type AuthContext struct {
	strategy AuthStrategy
}

func NewAuthContext(strategy AuthStrategy) *AuthContext {
	return &AuthContext{strategy: strategy}
}

func (ac *AuthContext) SetStrategy(strategy AuthStrategy) {
	ac.strategy = strategy
}

func (ac *AuthContext) Authenticate(ctx context.Context, repo UserRepository) e.Result[*User, error] {
	return ac.strategy.Execute(ctx, repo)
}
