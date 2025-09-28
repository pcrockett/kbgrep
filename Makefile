IMAGE_NAME ?= kbgrep-ci
ALL_SCRIPTS = tests/*.sh tests/*.bats src/*.sh src/lib/*.sh scripts/*.sh

all: format lint test
.PHONY: all

build: kbg
.PHONY: build

format: kbg
	shfmt --write $(ALL_SCRIPTS)
.PHONY: format

lint: kbg
	shellcheck ./kbg $(ALL_SCRIPTS)
.PHONY: lint

test: kbg
	KBGREP_ASSUME_TTY=1 bats tests
.PHONY: test

install: kbg
	cp kbg ~/.local/bin
.PHONY: install

release:
	gh workflow run release.yml
.PHONY: release

kbg: settings.yml src/bashly.yml src/*.sh src/lib/*.sh
	bashly generate

src/bashly.yml: src/bashly.cue .tool-versions
	rm -f src/bashly.yml
	cue export --outfile src/bashly.yml src/bashly.cue

ci:
	rm -f kbg src/bashly.yml
	@docker container rm --force "$(IMAGE_NAME)" &>/dev/null
	@docker build --tag "$(IMAGE_NAME)" .
	@docker run --name "$(IMAGE_NAME)" "$(IMAGE_NAME)" make all
	@docker cp "$(IMAGE_NAME)":/repo/kbg .
	@docker container rm "$(IMAGE_NAME)" &>/dev/null
	@test -f kbg
.PHONY: ci
