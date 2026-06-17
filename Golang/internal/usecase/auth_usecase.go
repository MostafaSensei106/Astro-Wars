package usecase

import (
	"errors"
	"time"

	"github.com/MostafaSensei106/Astro-Wars/Golang/internal/domain"
	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
)

type authUseCase struct {
	userRepo  domain.UserRepository
	jwtSecret string
}

func NewAuthUseCase(userRepo domain.UserRepository, jwtSecret string) domain.AuthUseCase {
	return &authUseCase{
		userRepo:  userRepo,
		jwtSecret: jwtSecret,
	}
}

func (u *authUseCase) Register(username, password string) (*domain.User, string, error) {
	existingUser, _ := u.userRepo.GetByUsername(username)
	if existingUser != nil {
		return nil, "", errors.New("username already exists")
	}

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return nil, "", err
	}

	user := &domain.User{
		Username:     username,
		PasswordHash: string(hashedPassword),
	}

	if err := u.userRepo.Create(user); err != nil {
		return nil, "", err
	}

	token, err := u.generateToken(user)
	if err != nil {
		return nil, "", err
	}

	return user, token, nil
}

func (u *authUseCase) Login(username, password string) (string, error) {
	user, err := u.userRepo.GetByUsername(username)
	if err != nil || user == nil {
		return "", errors.New("invalid username or password")
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(password)); err != nil {
		return "", errors.New("invalid username or password")
	}

	return u.generateToken(user)
}

func (u *authUseCase) ValidateToken(tokenString string) (*domain.AuthTokenClaims, error) {
	token, err := jwt.ParseWithClaims(tokenString, &domain.AuthTokenClaims{}, func(token *jwt.Token) (interface{}, error) {
		return []byte(u.jwtSecret), nil
	})

	if err != nil {
		return nil, err
	}

	if claims, ok := token.Claims.(*domain.AuthTokenClaims); ok && token.Valid {
		return claims, nil
	}

	return nil, errors.New("invalid token")
}

func (u *authUseCase) generateToken(user *domain.User) (string, error) {
	claims := &domain.AuthTokenClaims{
		UserID:   user.ID,
		Username: user.Username,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(24 * time.Hour)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString([]byte(u.jwtSecret))
}
