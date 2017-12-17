VERSION=0.1


.PHONY: build
build:  ## Build the dockrsync image
	docker build -t edaniszewski/dockrsync .

.PHONY: version
version:  ## Print dockrsync version
	@echo "${VERSION}"

.PHONY: help
help:  ## Print usage information
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

.DEFAULT_GOAL := help