package main

import (
	"fmt"
	"os"
	"path/filepath"

	qrcode "github.com/skip2/go-qrcode"
)

func main() {
	url := "https://example.com"
	outputFile := "./output/qrcode.png"
	size := 256

	os.MkdirAll("./output", 0755)

	qr, err := qrcode.New(url, qrcode.High)
	if err != nil {
		fmt.Printf("Ошибка создания QR: %v\n", err)
		return
	}

	err = qr.WriteFile(size, outputFile)
	if err != nil {
		fmt.Printf("Ошибка сохранения: %v\n", err)
		return
	}

	absPath, _ := filepath.Abs(outputFile)
	fmt.Printf("QR-код сохранён: %s (%d×%d px)\n", absPath, size, size)
}