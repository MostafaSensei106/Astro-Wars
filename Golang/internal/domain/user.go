package domain

import "time"

type User struct {
	BaseEntity
	Fullname     string    `json:"fullname" gorm:"type:varchar(100)"`
	Username     string    `json:"username" gorm:"type:varchar(50);uniqueIndex;not null"`
	PasswordHash string    `json:"-" gorm:"type:varchar(255);not null"`
	UserStats    UserStats `json:"stats"    gorm:"embedded"`
}

type GDGInfo struct {
	College       string `json:"college" gorm:"type:varchar(100)"`
	Department    string `json:"department" gorm:"type:varchar(100)"`
	AcademicYear  int    `json:"academic_year" gorm:"type:int"`
	GdgTrack      string `json:"gdg_track" gorm:"type:varchar(50)"`
	SystemRole    string `json:"system_role" gorm:"type:varchar(20);default:player"`
	CommunityRole string `json:"community_role" gorm:"type:varchar(50);default:member"` // core team - head - vice head -  facilitator - lead - co - lead - member
}

type UserStats struct {
	Level         int       `json:"level"          gorm:"type:int;not null;default:1"`
	Experience    int       `json:"experience"     gorm:"type:int;not null;default:0"`
	Coins         int       `json:"coins"          gorm:"type:int;not null;default:0"`
	Points        int       `json:"points"         gorm:"type:int;not null;default:0"`
	CurrentStreak int       `json:"current_streak" gorm:"type:int;not null;default:0"`
	MaxStreak     int       `json:"max_streak"     gorm:"type:int;not null;default:0"`
	LastPlayedAt  time.Time `json:"last_played_at" gorm:"type:timestamp;default:null"`
}
