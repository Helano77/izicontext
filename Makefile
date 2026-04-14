# izicontext build system
# Bundles src/ modules into a single executable

SOURCES = \
	src/header.sh \
	src/core/colors.sh \
	src/core/icons.sh \
	src/core/ui.sh \
	src/core/spinner.sh \
	src/core/utils.sh \
	src/setup/notifications.sh \
	src/setup/mcp.sh \
	src/commands/init.sh \
	src/commands/update.sh \
	src/commands/doctor.sh \
	src/commands/help.sh \
	src/commands/completion.sh \
	src/main.sh

OUTPUT = izicontext

.PHONY: build clean release

build: $(OUTPUT)

$(OUTPUT): $(SOURCES)
	@echo "Building $(OUTPUT)..."
	@cat $(SOURCES) > $(OUTPUT)
	@chmod +x $(OUTPUT)
	@echo "Done: $(OUTPUT) ($$(wc -l < $(OUTPUT)) lines)"

clean:
	@rm -f $(OUTPUT)

# Usage: make release VERSION=0.2.0
release: build
	@[ -n "$(VERSION)" ] || (echo "Error: VERSION is required (e.g. make release VERSION=0.2.0)" && exit 1)
	@sed -i'' -e 's/^VERSION=.*/VERSION="$(VERSION)"/' src/header.sh
	@make build
	@git add src/header.sh izicontext
	@git commit -m "bump: v$(VERSION)"
	@git tag v$(VERSION)
	@git push origin main v$(VERSION)
	@echo "Released v$(VERSION) — GitHub Actions will create the release"
