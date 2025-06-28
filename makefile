.DEFAULT_GOAL := all
SHELL := /bin/bash
NUM_THREADS?=1

ifeq ($(OS),Windows_NT)
	CURRENT_DATETIME := $(shell powershell -Command "Get-Date -Format 'yyyyMMdd:HH:mm:ss'")
else
	CURRENT_DATETIME := $(shell date +%Y%m%d:%H:%M:%S)
endif

.PHONY: c ## Create a new commit with the current date and time
c:
	git add .
	git commit -m "$(CURRENT_DATETIME)"
	git push

.PHONY: .uv  ## Check dependency
.uv:
	@uv -V || echo 'Please install uv: https://docs.astral.sh/uv/getting-started/installation/'

.PHONY: .aqua
	@aqua version || echo 'Please install aqua: https://aquaproj.github.io/docs/install'

.PHONY: .d ## Check dependency
dependency: .uv .aqua
		@echo 'ok'

.PHONY: cli ## Install CLI tools
cli: .d
	aqua i

.PHONY: config ## Install Configuration
cli: .d
	uv run --script scripts/install.py

.PHONY: all ## Install All
all: .d cli config

.PHONY: help  ## Display this message
help:
	@grep -E \
		'^.PHONY: .*?## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ".PHONY: |## "}; {printf "\033[36m%-19s\033[0m %s\n", $$2, $$3}'
