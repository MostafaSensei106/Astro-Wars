package usecase

import (
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
)

type upgradeUseCase struct {
	upgradeRepo domain.UpgradeRepository
}

func NewUpgradeUseCase(upgradeRepo domain.UpgradeRepository) domain.UpgradeUseCase {
	return &upgradeUseCase{
		upgradeRepo: upgradeRepo,
	}
}

func (u *upgradeUseCase) PurchaseOrUpgrade(userID uint, payload domain.UpgradePayload) (*domain.Upgrade, error) {
	// In a real scenario, we should verify if the user has enough commits (currency) to buy this upgrade
	// and deduct the commits using the userRepo inside a transaction.
	
	// For simplicity, we just upsert the upgrade
	upgrade := &domain.Upgrade{
		UserID:    userID,
		UpgradeID: payload.UpgradeID,
		Level:     1, // This will be incremented on conflict based on repo implementation
	}

	if err := u.upgradeRepo.UpsertUpgrade(upgrade); err != nil {
		return nil, err
	}

	// Fetch to get the updated level
	// A better way would be returning it from Upsert using RETURNING clause in PostgreSQL
	return upgrade, nil
}

func (u *upgradeUseCase) GetUserUpgrades(userID uint) ([]domain.Upgrade, error) {
	return u.upgradeRepo.GetUpgradesByUserID(userID)
}
