#!/usr/bin/env bats

source tests/util.sh

@test 'type - none specified - returns all files' {
    echo "a" > foo.md
    echo "a" > foo.py
    echo "a" > foo.sh
    echo "a" > foo.txt

    capture_output sorted kbg a
    assert_no_stderr
    assert_stdout '^foo\.md
foo\.py
foo\.sh
foo\.txt$'
    assert_exit_code 0
}

@test 'type - none specified (ANY) - returns all files' {
    echo "a" > foo.md
    echo "a" > foo.py
    echo "a" > foo.sh
    echo "a" > foo.txt

    capture_output sorted kbg --any a
    assert_no_stderr
    assert_stdout '^foo\.md
foo\.py
foo\.sh
foo\.txt$'
    assert_exit_code 0
}

@test 'type - markdown specified - returns md files' {
    echo "a" > foo.md
    echo "a" > foo.py
    echo "a" > foo.sh
    echo "a" > foo.txt

    capture_output kbg --type markdown a
    assert_no_stderr
    assert_stdout '^foo\.md$'
    assert_exit_code 0
}

@test 'type - markdown specified (ANY) - returns md files' {
    echo "a" > foo.md
    echo "a" > foo.py
    echo "a" > foo.sh
    echo "a" > foo.txt

    capture_output kbg --type markdown --any a
    assert_no_stderr
    assert_stdout '^foo\.md$'
    assert_exit_code 0
}
