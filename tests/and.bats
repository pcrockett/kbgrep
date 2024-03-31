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

@test 'and - funky search terms - escapes properly' {
    # shellcheck disable=SC2028  # i'm not trying to do escape sequences
    echo 'foo\bar' > slash.txt
    echo 'foo"bar' > quote.txt
    echo 'foo\ bar' > slash-space.txt
    # shellcheck disable=SC2028  # i'm not trying to do escape sequences
    echo 'foobar\n' > slash-n.txt
    echo 'foobar*' > star.txt

    capture_output kbg 'foo\bar'
    assert_no_stderr
    assert_stdout '^slash.txt$'
    assert_exit_code 0

    capture_output kbg 'foo"bar'
    assert_no_stderr
    assert_stdout '^quote.txt$'
    assert_exit_code 0

    capture_output kbg 'foo\ bar'
    assert_no_stderr
    assert_stdout '^slash-space.txt$'
    assert_exit_code 0

    capture_output kbg 'foobar\n'
    assert_no_stderr
    assert_stdout '^slash-n.txt$'
    assert_exit_code 0

    capture_output kbg 'foobar*'
    assert_no_stderr
    assert_stdout '^star.txt$'
    assert_exit_code 0

    capture_output kbg 'foo bar'
    assert_no_stderr
    assert_no_stdout
    assert_exit_code 0
}
