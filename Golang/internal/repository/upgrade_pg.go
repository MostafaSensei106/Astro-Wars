package repository

import (
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type upgradePgRepository struct {
	db *gorm.DB
}

func NewUpgradePgRepository(db *gorm.DB) domain.UpgradeRepository {
	return &upgradePgRepository{db: db}
}

func (r *upgradePgRepository) UpsertUpgrade(upgrade *domain.Upgrade) error {
	// If the user already has this upgrade, increment the level or update it
	return r.db.Clauses(clause.OnConflict{
		Columns:   []clause.Column{{Name: "user_id"}, {Name: "upgrade_id"}},
		DoUpdates: clause.AssignmentColumns([]string{"level", "updated_at"}),
	}).Create(upgrade).Error
}

func (r *upgradePgRepository) GetUpgradesByUserID(userID uint) ([]domain.Upgrade, error) {
	var upgrades []domain.Upgrade
	err := r.db.Where("user_id = ?", userID).Find(&upgrades).Error
	if err != nil {
		return nil, err
	}
	return upgrades, nil
}
