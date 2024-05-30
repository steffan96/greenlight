help:
    @echo 'Usage:' && \
    sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | \
    sed -e 's/^/ /'

confirm:
	@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y ]

## run/api: run the cmd/api application
.PHONY: 
run/api: #A phony target is one that is not really the name of a file; rather it is just a name for a rule to be executed.
	go run ./cmd/api -db-dsn=${GREENLIGHT_DB_DSN}

db/psql:
	psql ${GREENLIGHT_DB_DSN}

db/migrations/up: confirm
	@echo 'Running up migrations...'
	migrate -path ./migrations -database ${GREENLIGHT_DB_DSN} up

db/migrations/new:
	@echo 'Creating migration files for ${name}...'
	migrate create -seq -ext=.sql -dir=./migrations ${name}

.PHONY: audit
audit: vendor
	@echo 'Formatting code...'
	go fmt ./...
	@echo 'Vetting code...'
	go vet ./...
	staticcheck ./...
	@echo 'Running tests...'
	go test -race -vet=off ./...

## vendor: tidy and vendor dependencies
.PHONY: vendor
vendor:
	@echo 'Tidying and verifying module dependencies...'
	go mod tidy
	go mod verify
	@echo 'Vendoring dependencies...'
	go mod vendor

## build/api: build the cmd/api application
.PHONY: build/api
build/api:
	@echo 'Building cmd/api...'
	@mkdir -p ./bin
	go build -ldflags='-s' -o ./bin/api ./cmd/api GOOS=linux GOARCH=amd64 
	go build -ldflags='-s' -o ./bin/linux_amd64/api ./cmd/api
