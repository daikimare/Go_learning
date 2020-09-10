# メタ情報
NAME :=Go_learning
VERSION := $(gobump show -r)
REVISION := $(shell git rev-parse --short HEAD)
LDFLAGS := "-X main.revision=$(REVISION)"

export GO111MODULE=on

## Install dependencies
.PHONY: deps
deps:
	go get -v -d

# 開発に必要な依存をインストール
## Setup
.PHONY: deps
devel-deps: deps
	GO111MODULE=off go get \
		github.com/golang/lint/golint 		   \
		github.com/metemen/gobump/cmd/gobump \
		github.com/Songmu/make2help/cmd/make2help

# テストを実行
## Run tests
.PHONY: test
test: deps
	go test ./...

## Lint
.PHONY: lint
lint: devel-deps
	go vet ./...
	golint -set_exit_status ./...

## buils binaries ex. make bin/Go_learning
bin/%/: cmd/%/main.go deps
	go build -ldflags "$(LDFLAGS)" -o $@ $<

## build binary
.PHONY: build
build: bin.Go_learning

## Show help
.PHONY: help
help:
	@make2help $(MAKEFILE_LIST)