package main

import "github.com/MostafaSensei106/Astro-Wars/Golang/cmd"

// @title Astro Wars API
// @version 1.0
// @description Astro Wars Backend API
// @securityDefinitions.apikey BearerAuth
// @in header
// @name Authorization
// @BasePath /api/v1
func main() {
	cmd.Execute()
}
