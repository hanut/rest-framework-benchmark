package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

type AbStats struct {
	Framework    string
	Load         string
	TimeTaken    string
	Rps          string
	Mtpr         string
	TransferRate string
}

func (ab AbStats) String() string {
	return fmt.Sprintf(`{
   Framework:     %s
   Load:          %s
   TimeTaken:     %s
   TransferRate:  %s
   Mtpr:          %s
   Rps:           %s
}`, ab.Framework, ab.Load, ab.TimeTaken, ab.TransferRate, ab.Mtpr, ab.Rps)
}

func main() {
	files := getFilesList()
	if files == nil {
		panic("No files found")
	}
	for _, file := range files {
		fc, err := os.ReadFile(file)
		if err != nil {
			panic(err)
		}
		stats := extractStats(string(fc))
		fnp := strings.Split(strings.Trim(file, ".txt"), "-")
		stats.Framework = fnp[0]
		stats.Load = fnp[1]
		fmt.Println(stats)
	}
}

func getFilesList() []string {
	pattern := "results/*.txt*"
	matches, _ := filepath.Glob(pattern)
	return matches
}

func extractStats(contents string) AbStats {
	lines := strings.Split(contents, "\n")[15:]
	stats := AbStats{
		TimeTaken:    "",
		TransferRate: "",
		Rps:          "",
		Mtpr:         "",
	}
	for idx, line := range lines {
		switch idx {
		case 0:
			stats.TimeTaken = strings.Trim(strings.Trim(strings.Trim(line, "Time taken for tests:"), "second"), " ")
		case 7:
			stats.Rps = strings.Trim(strings.Trim(strings.Trim(line, "Requests per second:"), "[#/sec] (mean)"), " ")
		case 8:
			stats.Mtpr = strings.Trim(strings.Trim(strings.Trim(line, "Time per request:"), "[ms] (mean)"), " ")
		case 11:
			stats.TransferRate = strings.Trim(strings.Trim(line, "kb/s sent"), " ")
		}
	}
	return stats
}
