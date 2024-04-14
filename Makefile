all: lint test
.PHONY: all

build: kbg
.PHONY: build

lint: kbg
	shellcheck ./kbg src/*.sh tests/*.sh tests/*.bats
.PHONY: lint

test: kbg
	bats tests
.PHONY: test

install: kbg
	cp kbg ~/.local/bin
.PHONY: install

kbg: settings.yml src/bashly.yml src/*.sh src/lib/*.sh
	bashly generate

src/bashly.yml: src/bashly.cue .tool-versions
	rm -f src/bashly.yml
	cue export --outfile src/bashly.yml src/bashly.cue
