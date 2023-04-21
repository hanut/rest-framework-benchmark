package main

import (
	"fmt"
	"time"

	"github.com/gofiber/fiber/v2"
)

type LoginDto struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type LoginResDto struct {
	Username string `json:"username"`
	Role     string `json:"role"`
}

func main() {
	// Custom config
	app := fiber.New(fiber.Config{
		Prefork:       false,
		CaseSensitive: true,
		StrictRouting: true,
		ServerHeader:  "Fiber",
		AppName:       "Simple Fiber Test",
	})

	app.Use(func(c *fiber.Ctx) error {
		fmt.Printf("%v %v %v\n", time.Now().UnixMilli(), c.Method(), c.Path())
		// Go to next middleware:
		return c.Next()
	})

	app.Post("/", func(c *fiber.Ctx) error {
		data := new(LoginDto)
		if err := c.BodyParser(data); err != nil {
			return err
		}
		if data.Email != "hanutsingh@gmail.com" || data.Password != "qweasd@123" {
			return fiber.ErrUnauthorized
		}
		resData := LoginResDto{Username: "hanut", Role: "super admin"}
		return c.Status(200).JSON(resData)
	})

	app.Listen("localhost:3000")
}
