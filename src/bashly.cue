let bin_name = "kbg"

name:    bin_name
help:    "Knowledgebase grep: A search tool optimized for knowledgebases"
version: "0.1.0"
dependencies: {
	rg: "Ripgrep installation instructions: <https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation>"
}

catch_all: {
	label:    "terms"
	help:     "Terms to search for"
	required: true
}

flags: [{
	// TODO: make repeatable
	long:  "--type"
	short: "-t"
	arg:   "FILE_TYPE"
	help:  "File type as defined by `rg --type-list`"
}, {
	long:  "--any"
	short: "-a"
	help:  "Return files that contain at least one term"
}, {
	long:  "--full-words"
	short: "-w"
	help:  "Search for full words"
}, {
	long:  "--select"
	short: "-s"
	help: "Interactive file select dialog at end of search"
}, {
	long:  "--edit"
	short: "-e"
	help: "Edit search results in your \\$EDITOR"
}]

examples: [
"""
\\
# Search for markdown files that contain BOTH terms "foo" and "bar"
# Prompt the user to select files from the search results
# Edit all selected files with \\$EDITOR
\(bin_name) --type markdown --select --edit foo bar
""",
"""
\\
# Search for markdown files containing EITHER "bash" OR "shell"
# Narrow down search results containing the phrase "mac address"
# Prompt the user to select file(s) and edit them in \\$EDITOR
\(bin_name) --type markdown --any bash shell \\ \\
  | \(bin_name) --select --edit "mac address"
""",
]
