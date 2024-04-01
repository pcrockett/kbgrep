#!/usr/bin/env bats

source tests/util.sh

@test 'select - returns search results - runs fzf' {
    echo "a" > a.txt

    # tell our fzf mock to output "a.txt" -- simulating a user that selected "a.txt"
    export MOCK_STDOUT="a.txt"

    capture_output kbg a --select
    assert_stderr '^program_name=fzf
arg\.0=--multi
arg\.1=--exit-0
stdin=a\.txt$'
    assert_stdout '^a\.txt$'
    assert_exit_code 0
}

@test 'select - returns no search results - runs fzf' {
    echo "a" > a.txt
    capture_output kbg "this should not exist" --select
    assert_stderr '^program_name=fzf
arg\.0=--multi
arg\.1=--exit-0
stdin=$'
    assert_no_stdout
    assert_exit_code 1
}
