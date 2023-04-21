package main

import (
	"fmt"
	"os"
	"path"
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

type AbStatsReport = []AbStats

func writeToCsv(abr AbStatsReport, path string) {
	var csv string = "Framework,Load,Time Taken(s),Transfer Rate(KB/s),Mean Time Per Request(ms),Average Throughput(Req/s)\n"
	for _, v := range abr {
		csv += fmt.Sprintf("%s,%s,%s,%s,%s,%s\r\n", v.Framework, v.Load, v.TimeTaken, v.TransferRate, v.Mtpr, v.Rps)
	}
	os.WriteFile(path, []byte(csv), 0700)
}

func main() {
	files := getFilesList()
	if files == nil {
		panic("No files found")
	}
	results := make(AbStatsReport, len(files))
	for i, file := range files {
		fc, err := os.ReadFile(file)
		if err != nil {
			panic(err)
		}
		results[i] = extractStats(string(fc))
	}
	cwd, _ := os.Getwd()
	writeToCsv(results, path.Join(cwd, "result.csv"))
}

func getFilesList() []string {
	pattern := "./results/*.txt*"
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
	// stores the index to the 3rd last line since we know that is
	// going to be our benchmark test data
	tdIdx := len(lines) - 3
	for idx, line := range lines {
		switch idx {
		case 0:
			stats.TimeTaken = "00:00:" + strings.Trim(strings.Trim(strings.Trim(line, "Time taken for tests:"), "second"), " ")
		case 7:
			stats.Rps = strings.Trim(strings.Trim(strings.Trim(line, "Requests per second:"), "[#/sec] (mean)"), " ")
		case 8:
			stats.Mtpr = strings.Trim(strings.Trim(strings.Trim(line, "Time per request:"), "[ms] (mean)"), " ")
		case 12:
			stats.TransferRate = strings.Trim(strings.Split(line, "kb/s")[0], " ")
		case tdIdx:
			stats.Framework = strings.Split(line, ":")[1]
		case tdIdx + 1:
			stats.Load = strings.Split(line, ":")[1]
		}
	}
	return stats
}
