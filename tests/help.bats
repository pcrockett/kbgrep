#!/usr/bin/env bats

source tests/util.sh

@test 'help - always - shows help message' {
    capture_output kbg --help
    assert_no_stderr
    # shellcheck disable=SC2016  # dollar signs are supposed to be literal:
    assert_stdout '^kbg - Knowledgebase grep: A search tool optimized for knowledgebases

Usage:
  kbg \[OPTIONS] \[--] TERMS\.\.\.
  kbg --help \| -h
  kbg --version \| -v'

    assert_exit_code 0
}
