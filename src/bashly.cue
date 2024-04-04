let bin_name = "kbg"

name:    bin_name
help:    "Knowledgebase grep: A search tool optimized for knowledgebases"
version: "0.1.0"
dependencies: {
	rg: "Ripgrep installation instructions: <https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation>"
}

catch_all: {
	label: "terms"
	help:  "Terms to search for"
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
	long:  "--edit"
	short: "-e"
	help: "Edit search results in your \\$EDITOR"
}]

examples: [
"""
\\
# Interactive search UI
\(bin_name)
""",
"""
\\
# Search for markdown files that contain BOTH terms "foo" and "bar"
# Edit search results with \\$EDITOR
\(bin_name) --type markdown --edit foo bar
""",
"""
\\
# Search for markdown files containing EITHER "bash" OR "shell"
# Narrow down search results containing the phrase "mac address"
# Edit search results with \\$EDITOR
\(bin_name) --type markdown --any bash shell \\ \\
  | \(bin_name) --edit "mac address"
""",
]
