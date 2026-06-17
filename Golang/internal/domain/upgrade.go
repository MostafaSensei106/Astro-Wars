package domain

import "time"

type Upgrade struct {
	ID        uint      `json:"id" gorm:"primaryKey"`
	UserID    uint      `json:"user_id" gorm:"index;uniqueIndex:idx_user_upgrade;not null"`
	UpgradeID string    `json:"upgrade_id" gorm:"uniqueIndex:idx_user_upgrade;not null"`
	Level     int       `json:"level" gorm:"default:1;not null"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type UpgradePayload struct {
	UpgradeID string `json:"upgrade_id" binding:"required"`
}

type UpgradeRepository interface {
	UpsertUpgrade(upgrade *Upgrade) error
	GetUpgradesByUserID(userID uint) ([]Upgrade, error)
}

type UpgradeUseCase interface {
	PurchaseOrUpgrade(userID uint, payload UpgradePayload) (*Upgrade, error)
	GetUserUpgrades(userID uint) ([]Upgrade, error)
}
