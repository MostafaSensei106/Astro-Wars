package domain

import (
	"context"
	e "github.com/MostafaSensei106/Astro-Wars/Golang/internal/errors"
)

type Runs struct {
	BaseEntity
	UserID       string `json:"user_id" gorm:"foreignKey:UserID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	Score        int    `json:"score" gorm:"type:int;not null" example:"1500"`                               // Represents commits/points earned
	Duration     int64  `json:"duration" gorm:"type:int;not null" example:"120"`                             // Survived time in seconds
	CauseOfDeath string `json:"cause_of_death" gorm:"type:varchar(255)" example:"NullPointerException Boss"` // The bug that killed the player

	// Story-Driven Stats
	BugsSquashed   int     `json:"bugs_squashed" gorm:"type:int;default:0" example:"45"`  // Regular enemies destroyed
	BossesDefeated int     `json:"bosses_defeated" gorm:"type:int;default:0" example:"1"` // Bosses destroyed
	MaxFlowState   int     `json:"max_flow_state" gorm:"type:int;default:0" example:"15"` // Max kill streak without taking damage
	Accuracy       float64 `json:"accuracy" gorm:"type:float;default:0" example:"85.5"`   // Hit accuracy (Clean Code rate)
	CoffeeCups     int     `json:"coffee_cups" gorm:"type:int;default:0" example:"3"`     // Power-ups collected
}

type RunRepository interface {
	Create(ctx context.Context, run *Runs) e.Result[*Runs, error]
	FindByUserID(ctx context.Context, userID string) e.Result[[]Runs, error]
}

type RunUseCase interface {
	SaveRun(ctx context.Context, run *Runs) e.Result[*Runs, error]
	GetUserRuns(ctx context.Context, userID string) e.Result[[]Runs, error]
}
