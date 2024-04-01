#!/usr/bin/env bats

source tests/util.sh

@test 'normal search - no search results - nonzero exit' {
    echo "a" > a.txt
    capture_output kbg b
    assert_no_stderr
    assert_no_stdout
    assert_exit_code 1
}

@test 'normal search - single term - finds files with term' {
    echo "a" > a.txt
    echo "b" > b.txt
    echo "c
a" > c.txt

    capture_output sorted kbg a
    assert_no_stderr
    assert_stdout '^a\.txt
c\.txt$'
    assert_exit_code 0
}

@test 'normal search - many terms - finds files with all terms' {
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

@test 'normal search - funky search terms - escapes properly' {
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
    assert_exit_code 1
}

@test 'normal search - always - case insensitive' {
    echo "Ab" > Ab.txt
    echo "aB" > aB.txt
    echo "AB" > AB.txt
    echo "ab" > ab.txt
    echo "c" > c.txt

    capture_output sorted kbg a b
    assert_no_stderr
    assert_stdout '^ab\.txt
aB\.txt
Ab\.txt
AB\.txt$'
    assert_exit_code 0
}

@test 'normal search - parameter name as term - still works' {
    echo "--type" > foo.txt

    capture_output kbg -- --type
    assert_no_stderr
    assert_stdout '^foo\.txt$'
    assert_exit_code 0
}
