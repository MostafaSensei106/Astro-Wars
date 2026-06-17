package domain

import (
	"context"
	"errors"
	"math"
	"time"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/constants"
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

type UserRepository interface {
	Create(ctx context.Context, user *User) error
	FindByUsername(ctx context.Context, username string) (*User, error)
	Update(ctx context.Context, user *User) (*User, error)
	Delete(ctx context.Context, id string) error
}

type UserUsecase interface {
	FindByUsername(ctx context.Context, username string) (*User, error)
	CreateUser(ctx context.Context, user *User) error
	UpdateUser(ctx context.Context, user *User) (*User, error)
	DeleteUser(ctx context.Context, id string) error
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
