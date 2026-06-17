package usecase

import (
	"errors"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
)

type runUseCase struct {
	runRepo  domain.RunRepository
	userRepo domain.UserRepository
}

func NewRunUseCase(runRepo domain.RunRepository, userRepo domain.UserRepository) domain.RunUseCase {
	return &runUseCase{
		runRepo:  runRepo,
		userRepo: userRepo,
	}
}

func (u *runUseCase) SyncRun(userID uint, payload domain.RunSyncPayload) (*domain.Run, error) {
	if payload.CommitsEarned < 0 {
		return nil, errors.New("invalid commits earned")
	}

	run := &domain.Run{
		UserID:        userID,
		CommitsEarned: payload.CommitsEarned,
		CauseOfDeath:  payload.CauseOfDeath,
		Duration:      payload.Duration,
		ProfilerData:  payload.ProfilerData,
	}

	// 1. Save the run history
	if err := u.runRepo.Create(run); err != nil {
		return nil, err
	}

	// 2. Update user's total commits
	if payload.CommitsEarned > 0 {
		if err := u.userRepo.UpdateTotalCommits(userID, payload.CommitsEarned); err != nil {
			// Ideally, this should be in a transaction to ensure consistency
			return nil, err
		}
	}

	return run, nil
}
