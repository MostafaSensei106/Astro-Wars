package domain

import (
	"context"

	e "github.com/MostafaSensei106/Astro-Wars/Golang/internal/errors"
)

type AppVersion struct {
	BaseEntity
	VersionName             string `json:"version_name" gorm:"type:varchar(20);not null;default:'1.0.0'" example:"1.0"`
	VersionCode             int    `json:"version_code" gorm:"type:int;not null;default:1" example:"1"`
	MinSupportedVersionCode int    `json:"min_supported_version_code" gorm:"type:int;not null;default:1" example:"1"`
	DownloadURL             string `json:"download_url" gorm:"type:varchar(255);not null" default:"https://github.com/MostafaSensei106/Astro-Wars/releases" example:"https://github.com/MostafaSensei106/Astro-Wars/releases"`
	ReleaseNotes            string `json:"release_notes" gorm:"type:text;not null;default:'Bug Fixes and Improvements'" example:"Bug Fixes and Improvements"`
	IsPublished             bool   `json:"is_published" gorm:"type:boolean;default:false"`
	MaintenanceMode         bool   `json:"maintenance_mode" gorm:"type:boolean;default:false"`
	MaintenanceMessage      string `json:"maintenance_message" gorm:"type:text;default:'The servers are currently under maintenance. Please try again later.'"`
}

type AppVersionRepository interface {
	Create(ctx context.Context, appVersion *AppVersion) e.Result[*AppVersion, error]
	GetLatestVersion(ctx context.Context, platform string) e.Result[*AppVersion, error]
	Update(ctx context.Context, appVersion *AppVersion) e.Result[*AppVersion, error]
	Delete(ctx context.Context, id string) e.Result[bool, error]
}

type AppVersionUseCase interface {
	GetLatestVersion(ctx context.Context, platform string) e.Result[*AppVersion, error]
	PublishVersion(ctx context.Context, appVersion *AppVersion) e.Result[*AppVersion, error]
}
