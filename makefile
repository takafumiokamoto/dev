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

.PHONY: help  ## Display this message
help:
	@grep -E \
		'^.PHONY: .*?## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ".PHONY: |## "}; {printf "\033[36m%-19s\033[0m %s\n", $$2, $$3}'
