#!/usr/bin/env bats
# shellcheck disable=SC2030,2031  # exported env vars only take effect inside a test

source tests/util.sh

@test 'edit - no search results - does nothing' {
    echo "a" > a.txt
    export EDITOR='echo "-->"'
    capture_output kbg --edit foobar
    assert_no_stderr
    assert_no_stdout
    assert_exit_code 1
}

@test 'edit - no search results (ANY) - does nothing' {
    echo "a" > a.txt
    export EDITOR='echo "-->"'
    capture_output kbg --any --edit foobar
    assert_no_stderr
    assert_no_stdout
    assert_exit_code 1
}

@test 'edit - single search result - edits file' {
    echo "a" > a.txt
    export EDITOR='echo "-->"'
    capture_output kbg --edit a
    assert_no_stderr
    assert_stdout '^--> a\.txt$'
    assert_exit_code 0
}

@test 'edit - single search result (ANY) - edits file' {
    echo "a" > a.txt
    export EDITOR='echo "-->"'
    capture_output kbg --any --edit a
    assert_no_stderr
    assert_stdout '^--> a\.txt$'
    assert_exit_code 0
}

@test 'edit - multiple search results - edits files' {
    echo "a" > a.txt
    echo "a" > b.txt
    export EDITOR='echo "-->"'
    capture_output sorted kbg --edit a
    assert_no_stderr
    assert_stdout '^--> '
    assert_stdout 'a\.txt'
    assert_stdout 'b\.txt'
    assert_exit_code 0
}

@test 'edit - multiple search results (ANY) - edits files' {
    echo "a" > a.txt
    echo "a" > b.txt
    export EDITOR='echo "-->"'
    capture_output sorted kbg --any --edit a
    assert_no_stderr
    assert_stdout '^--> '
    assert_stdout 'a\.txt'
    assert_stdout 'b\.txt'
    assert_exit_code 0
}

@test 'edit - EDITOR not defined - errors' {
    unset EDITOR
    capture_output kbg --edit a
    assert_no_stdout
    # shellcheck disable=SC2016  # i want literal backslash-dollarsign
    assert_stderr '^\$EDITOR environment variable is not defined.$'
    assert_exit_code 1
}
