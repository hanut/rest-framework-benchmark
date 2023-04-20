build_prod:
	cd .tools && go build -ldflags="-s -w" -o ../process