generate: kbg
.PHONY: generate

kbg: src/bashly.yml
	bashly generate

src/bashly.yml: src/bashly.cue .tool-versions
	rm -f src/bashly.yml
	cue export --outfile src/bashly.yml src/bashly.cue
