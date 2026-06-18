package handlers

import (
	"net/http"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/delivery"
	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	"github.com/gin-gonic/gin"
)

type AppVersionHandler struct {
	us domain.AppVersionUseCase
}

type CheckAppVersionRequest struct {
	Platform    string `json:"platform" binding:"required" example:"android"`
	VersionCode int    `json:"version_code" binding:"required" example:"105"`
}

type CheckAppVersionResponse struct {
	NeedUpdate         bool   `json:"need_update"`
	ForceUpdate        bool   `json:"force_update"`
	CurrentVersionCode int    `json:"current_version_code"`
	LatestVersionCode  int    `json:"latest_version_code"`
	LatestVersionName  string `json:"latest_version_name"`
	DownloadURL        string `json:"download_url"`
	ReleaseNotes       string `json:"release_notes"`
	MaintenanceMode    bool   `json:"maintenance_mode"`
	MaintenanceMessage string `json:"maintenance_message"`
}

func NewAppVersionHandler(usecase domain.AppVersionUseCase) *AppVersionHandler {
	return &AppVersionHandler{
		us: usecase,
	}
}

// CheckVersion godoc
// @Summary      Check App Version
// @Description  Checks if the current app version needs an update or a forced update based on the platform.
// @Tags         app-version
// @Accept       json
// @Produce      json
// @Param        request body CheckAppVersionRequest true "App Version Info"
// @Router       /api/v1/app/version/check [post]
func (h *AppVersionHandler) CheckVersion(c *gin.Context) {
	var req CheckAppVersionRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		delivery.NewResponser(c).Status(http.StatusBadRequest).WithError(http.StatusText(http.StatusBadRequest), err.Error()).Send()
		return
	}

	result := h.us.GetLatestVersion(c.Request.Context(), req.Platform)

	result.OnSuccess(func(latest *domain.AppVersion) {
		needUpdate := req.VersionCode < latest.VersionCode
		forceUpdate := req.VersionCode < latest.MinSupportedVersionCode

		res := CheckAppVersionResponse{
			NeedUpdate:         needUpdate,
			ForceUpdate:        forceUpdate,
			CurrentVersionCode: req.VersionCode,
			LatestVersionCode:  latest.VersionCode,
			LatestVersionName:  latest.VersionName,
			DownloadURL:        latest.DownloadURL,
			ReleaseNotes:       latest.ReleaseNotes,
			MaintenanceMode:    latest.MaintenanceMode,
			MaintenanceMessage: latest.MaintenanceMessage,
		}

		delivery.NewResponser(c).WithData(res).Send()
	}).OnFailure(func(err error) {
		delivery.NewResponser(c).Status(http.StatusInternalServerError).WithError(http.StatusText(http.StatusInternalServerError), err.Error()).Send()
	})
}
