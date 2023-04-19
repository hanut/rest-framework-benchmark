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
	var csv string
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
		fnp := strings.Split(strings.Trim(file, ".txt"), "-")
		results[i].Framework = getLabel(fnp[0][9:])
		// fmt.Println("File", file, "Framework", results[i].Framework)
		results[i].Load = fnp[1]
	}
	cwd, _ := os.Getwd()
	writeToCsv(results, path.Join(cwd, "result.csv"))
}

func getFilesList() []string {
	pattern := "../results/*.txt*"
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

func getLabel(framework string) string {
	var label string
	switch framework {
	case "bune":
		label = "Bun + Express"
	case "denoe":
		label = "Deno + Express"
	case "denoo":
		label = "Deno + Oak"
	case "nodex":
		label = "Node + Express"
	case "nodef":
		label = "Node + Fastify"
	case "neste":
		label = "Nest + Express"
	case "nestf":
		label = "Nest + Fastify"
	case "go":
		label = "Go + Fiber"
	case "cpp":
		label = "Cpp & Oat++"
	case "rust":
		label = "Rust + Actix"
	}
	return label
}
