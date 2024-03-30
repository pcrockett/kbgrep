#!/usr/bin/env bats

source tests/util.sh

@test 'help - always - shows help message' {
    capture_output kbg --help
    assert_exit_code 0
    # shellcheck disable=SC2016  # dollar signs are supposed to be literal:
    assert_stdout '^kbg - Knowledgebase grep: A search tool optimized for knowledgebases

Usage:
  kbg TERM\.\.\. \[OPTIONS]
  kbg --help | -h
  kbg --version | -v

Options:
  --type, -t FILE_TYPE
    File type as defined by `rg --type-list`

  --and, -a
    Return files that contain all terms

  --or, -o
    Return files that contain at least one term

  --select, -s
    Interactive file select dialog at end of search

  --edit, -e
    Edit search results in your $EDITOR

  --help, -h
    Show this help

  --version, -v
    Show version number

Arguments:
  TERM\.\.\.
    Term to search for

Examples:

  # Search for markdown files that contain BOTH terms "foo" and "bar"
  # Prompt the user to select files from the search results
  # Edit all selected files with $EDITOR
  kbg --type markdown --select --edit --and foo bar

  # Search for markdown files containing EITHER "bash" OR "shell"
  # Narrow down search results containing the phrase "mac address"
  # Prompt the user to select file(s) and edit them in $EDITOR
  kbg --type markdown --or bash shell \
    | kbg --select --edit "mac address"$
'

    assert_no_stderr
}
