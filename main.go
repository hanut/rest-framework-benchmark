package main

import (
	"fmt"
	"os"
	"path"
	"strings"
)

type AbStats struct {
	TimeTaken    string
	Rps          string
	Mtpr         string
	TransferRate string
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("this tool needs the filename to be passed as an argument")
		os.Exit(1)
	}
	fname := os.Args[1]
	cwd, _ := os.Getwd()
	fp := path.Join(cwd, "results", fname)
	fmt.Printf("Reading file %s\n", fp)
	file, err := os.ReadFile(fp)
	if err != nil {
		panic(err)
	}
	ExtractStats(string(file))
}

func ExtractStats(contents string) (AbStats, error) {
	lines := strings.Split(contents, "\n")
	for _, line := range lines {
		fmt.Println(line)
	}
	return AbStats{
		TimeTaken:    "",
		TransferRate: "",
		Rps:          "",
		Mtpr:         "",
	}, nil
}
