#!/usr/bin/env bats

source tests/util.sh

@test 'and - single term - finds files with term' {
    echo "a" > a.txt
    echo "b" > b.txt
    echo "c
a" > c.txt

    capture_output sorted kbg --and a
    assert_no_stderr
    assert_stdout '^a\.txt
c\.txt$'
    assert_exit_code 0
}

@test 'and - many terms - finds files with all terms' {
    echo "a" > a.txt
    echo "b" > b.txt
    echo "ca" > c.txt
    echo "dbc" > d.txt
    echo "ebca" > e.txt
    echo "c
a
b
f" > f.txt

    capture_output sorted kbg --and a b c
    assert_no_stderr
    assert_stdout '^e\.txt
f\.txt$'
    assert_exit_code 0
}

@test 'and - not specified on cli - is assumed' {
    echo "a" > a.txt
    echo "b" > b.txt
    echo "ca" > c.txt
    echo "dbc" > d.txt
    echo "ebca" > e.txt
    echo "c
a
b
f" > f.txt

    capture_output sorted kbg a b c
    assert_no_stderr
    assert_stdout '^e\.txt
f\.txt$'
    assert_exit_code 0
}
