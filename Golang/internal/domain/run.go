package domain

import (
	"time"
)

type Run struct {
	ID            uint      `json:"id" gorm:"primaryKey"`
	UserID        uint      `json:"user_id" gorm:"index;not null"`
	CommitsEarned int64     `json:"commits_earned" gorm:"not null"`
	CauseOfDeath  string    `json:"cause_of_death" gorm:"not null"` // Important for profiler system
	Duration      int64     `json:"duration" gorm:"not null"`       // Duration in seconds
	CreatedAt     time.Time `json:"created_at"`

	// Profiler metadata can be stored as JSON if needed
	ProfilerData string `json:"profiler_data,omitempty" gorm:"type:jsonb"`
}

type RunSyncPayload struct {
	CommitsEarned int64  `json:"commits_earned" binding:"required"`
	CauseOfDeath  string `json:"cause_of_death" binding:"required"`
	Duration      int64  `json:"duration" binding:"required"`
	ProfilerData  string `json:"profiler_data"`
}

type RunRepository interface {
	Create(run *Run) error
	GetRunsByUserID(userID uint, limit int) ([]Run, error)
}

type RunUseCase interface {
	SyncRun(userID uint, payload RunSyncPayload) (*Run, error)
}
