#!/usr/bin/env bats
# shellcheck disable=SC2030,SC2031  # exported variables are only good inside a given test

source tests/util.sh

assert_mock_args() {
    while [[ ${#} -gt 0 ]]; do
        assert_stderr "[[:space:]]arg=${1}[[:space:]]"
        shift
    done
}

@test 'select - returns search results - runs fzf' {
    echo "a" > a.txt

    # tell our fzf mock to output "a.txt" -- simulating a user that selected "a.txt"
    export MOCK_STDOUT="a.txt"

    capture_output kbg a --select

    assert_stderr '^program_name=fzf[[:space:]]'

    # shellcheck disable=SC2016  # i want my dollar signs to be literal
    assert_mock_args --multi \
        --preview 'bat\\ .+' \
        --preview-window 'up\\,.+'

    assert_stderr '.*stdin=a\.txt$'

    assert_stdout '^a\.txt$'
    assert_exit_code 0
}

@test 'select - returns search results (ANY) - runs fzf' {
    echo "a" > a.txt

    # tell our fzf mock to output "a.txt" -- simulating a user that selected "a.txt"
    export MOCK_STDOUT="a.txt"

    capture_output kbg a --select --any

    assert_stderr '^program_name=fzf[[:space:]]'
    assert_mock_args --multi \
        --preview 'bat\\ .+' \
        --preview-window 'up\\,.+'
    assert_stderr '.*stdin=a\.txt$'

    assert_stdout '^a\.txt$'
    assert_exit_code 0
}

@test 'select - returns no search results - runs fzf' {
    echo "a" > a.txt
    capture_output kbg "this should not exist" --select

    assert_stderr '^program_name=fzf[[:space:]]'
    assert_mock_args --exit-0
    assert_stderr 'stdin=$'

    assert_no_stdout
    assert_exit_code 1
}

@test 'select - returns no search results (ANY) - runs fzf' {
    echo "a" > a.txt
    capture_output kbg "this should not exist" --select --any

    assert_stderr '^program_name=fzf[[:space:]]'
    assert_mock_args --exit-0
    assert_stderr 'stdin=$'

    assert_no_stdout
    assert_exit_code 1
}

@test 'select - via env variable - runs fzf' {
    echo "a" > a.txt
    export MOCK_STDOUT="this came from fzf"
    export KBGREP_SELECT=1

    capture_output kbg a
    assert_stderr '^program_name=fzf[[:space:]]'
    assert_stdout '^this came from fzf$'
    assert_exit_code 0
}

@test 'select - via env variable (ANY) - runs fzf' {
    echo "a" > a.txt
    export MOCK_STDOUT="this came from fzf"
    export KBGREP_SELECT=1

    capture_output kbg --any a
    assert_stderr '^program_name=fzf[[:space:]]'
    assert_stdout '^this came from fzf$'
    assert_exit_code 0
}
