package cmd

type config struct {
	port string
	db   dbConfig
}

type dbConfig struct {
	dns string
}
