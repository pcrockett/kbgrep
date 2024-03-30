#!/usr/bin/env bats

source tests/util.sh

@test 'or - single term - finds files with term' {
    echo "a" > a.txt
    echo "b" > b.txt
    echo "c
a" > c.txt

    capture_output sorted kbg --or a
    assert_no_stderr
    assert_stdout '^a\.txt
c\.txt$'
    assert_exit_code 0
}

@test 'or - many terms - finds files with any term' {
    echo "a" > a.txt
    echo "b" > b.txt
    echo "c
a" > c.txt
    echo "d" > d.txt

    capture_output sorted kbg --or a b c
    assert_no_stderr
    assert_stdout '^a\.txt
b\.txt
c\.txt$'
    assert_exit_code 0
}
