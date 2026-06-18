package domain

type AppVersion struct {
	BaseEntity
	Version     string `json:"version" gorm:"type:varchar(20);not null;unique" example:"1.0.2"`
	Platform    string `json:"platform" gorm:"type:varchar(20);not null" example:"Android"` // Android, iOS, Windows
	IsMandatory bool   `json:"is_mandatory" gorm:"default:false" example:"true"`
	DownloadURL string `json:"download_url" gorm:"type:text" example:"https://play.google.com/store/apps/details?id=com.astrowars"`
	ReleaseNote string `json:"release_note" gorm:"type:text" example:"Fixed NullPointerException Boss bug"`
}
