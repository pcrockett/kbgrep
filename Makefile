all: lint test
.PHONY: all

generate: kbg
.PHONY: generate

lint: kbg
	shellcheck ./kbg src/*.sh tests/*.sh tests/*.bats
.PHONY: lint

test: kbg
	bats ./tests
.PHONY: test

kbg: src/bashly.yml src/*.sh src/lib/*.sh
	bashly generate

src/bashly.yml: src/bashly.cue .tool-versions
	rm -f src/bashly.yml
	cue export --outfile src/bashly.yml src/bashly.cue
