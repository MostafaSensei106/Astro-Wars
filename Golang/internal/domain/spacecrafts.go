package domain

import (
	"context"
	"time"

	e "github.com/MostafaSensei106/Astro-Wars/Golang/internal/errors"
)

type Spacecraft struct {
	BaseEntity
	UserID     string    `json:"user_id" gorm:"foreignKey:UserID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	Name       string    `json:"name" gorm:"type:varchar(100);not null" example:"Vim Fighter"`
	Rarity     string    `json:"rarity" gorm:"type:varchar(50);default:'Common'" example:"Epic"`
	Level      int       `json:"level" gorm:"type:int;default:1" example:"5"`
	IsEquipped bool      `json:"is_equipped" gorm:"type:boolean;default:false" example:"true"`
	UnlockedAt time.Time `json:"unlocked_at" gorm:"type:timestamp;default:CURRENT_TIMESTAMP" example:"2024-01-01T12:00:00Z"`
}

type SpacecraftRepository interface {
	Create(ctx context.Context, spacecraft *Spacecraft) e.Result[*Spacecraft, error]
	FindByUserID(ctx context.Context, userID string) e.Result[[]Spacecraft, error]
	FindByID(ctx context.Context, id string) e.Result[*Spacecraft, error]
	Update(ctx context.Context, spacecraft *Spacecraft) e.Result[*Spacecraft, error]
}

type SpacecraftUseCase interface {
	CreateSpacecraft(ctx context.Context, spacecraft *Spacecraft) e.Result[*Spacecraft, error]
	GetUserSpacecrafts(ctx context.Context, userID string) e.Result[[]Spacecraft, error]
	EquipSpacecraft(ctx context.Context, userID, spacecraftID string) e.Result[*Spacecraft, error]
	UpgradeSpacecraft(ctx context.Context, userID, spacecraftID string) e.Result[*Spacecraft, error]
}
