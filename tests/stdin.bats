#!/usr/bin/env bats

source tests/util.sh

@test 'stdin - empty - searches as usual' {
    echo "a" > a.txt
    capture_output kbg a < /dev/null
    assert_no_stderr
    assert_stdout '^a\.txt$'
    assert_exit_code 0
}

@test 'stdin - contains file paths - searches only those files' {
    echo "a" > "1.txt"
    echo "a" > "2.txt"
    echo "a" > "3.txt"
    capture_output sorted kbg a < <(echo "1.txt" "2.txt")
    assert_no_stderr
    assert_stdout '^1\.txt
2\.txt$'
    assert_exit_code 0
}

@test 'stdin - empty (ANY) - searches as usual' {
    echo "a" > a.txt
    capture_output kbg --any a < /dev/null
    assert_no_stderr
    assert_stdout '^a\.txt$'
    assert_exit_code 0
}

@test 'stdin - contains file paths (ANY) - searches only those files' {
    echo "a" > "1.txt"
    echo "a" > "2.txt"
    echo "a" > "3.txt"
    capture_output sorted kbg --any a < <(echo "1.txt" "2.txt")
    assert_no_stderr
    assert_stdout '^1\.txt
2\.txt$'
    assert_exit_code 0
}
