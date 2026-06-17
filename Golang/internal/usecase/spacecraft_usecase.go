package usecase

import (
	"context"
	"errors"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	e "github.com/MostafaSensei106/Astro-Wars/Golang/internal/errors"
)

type spacecraftUseCase struct {
	repo domain.SpacecraftRepository
}

func NewSpacecraftUseCase(repo domain.SpacecraftRepository) domain.SpacecraftUseCase {
	return &spacecraftUseCase{repo: repo}
}

func (uc *spacecraftUseCase) CreateSpacecraft(ctx context.Context, s *domain.Spacecraft) e.Result[*domain.Spacecraft, error] {
	return uc.repo.Create(ctx, s)
}

func (uc *spacecraftUseCase) GetUserSpacecrafts(ctx context.Context, userID string) e.Result[[]domain.Spacecraft, error] {
	return uc.repo.FindByUserID(ctx, userID)
}

func (uc *spacecraftUseCase) EquipSpacecraft(ctx context.Context, userID, spacecraftID string) e.Result[*domain.Spacecraft, error] {
	listResult := uc.repo.FindByUserID(ctx, userID)
	if listResult.IsFailure() {
		err := listResult.ErrorOrNull()
		if err == nil {
			return e.Failure[*domain.Spacecraft](errors.New("unknown error"))
		}
		return e.Failure[*domain.Spacecraft](*err)
	}

	for _, sc := range *listResult.DataOrNull() {
		if sc.IsEquipped && sc.ID != spacecraftID {
			sc.IsEquipped = false
			uc.repo.Update(ctx, &sc)
		}
	}

	scResult := uc.repo.FindByID(ctx, spacecraftID)
	if scResult.IsFailure() {
		return scResult
	}

	sc := *scResult.DataOrNull()
	if sc.UserID != userID {
		return e.Failure[*domain.Spacecraft](errors.New("unauthorized to equip this spacecraft"))
	}

	sc.IsEquipped = true
	return uc.repo.Update(ctx, sc)
}

func (uc *spacecraftUseCase) UpgradeSpacecraft(ctx context.Context, userID, spacecraftID string) e.Result[*domain.Spacecraft, error] {
	scResult := uc.repo.FindByID(ctx, spacecraftID)
	if scResult.IsFailure() {
		return scResult
	}

	sc := *scResult.DataOrNull()
	if sc.UserID != userID {
		return e.Failure[*domain.Spacecraft](errors.New("unauthorized to upgrade this spacecraft"))
	}

	sc.Level += 1
	return uc.repo.Update(ctx, sc)
}
