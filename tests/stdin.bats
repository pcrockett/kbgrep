#!/usr/bin/env bats
# shellcheck disable=SC2030,2031  # exported env vars only take effect inside a test

source tests/util.sh

@test 'stdin - empty - returns nothing' {
    export KBGREP_ASSUME_TTY=
    echo "a" > a.txt
    capture_output kbg a < /dev/null
    assert_no_stderr
    assert_no_stdout
    assert_exit_code 0
}

@test 'stdin - contains file paths - searches only those files' {
    export KBGREP_ASSUME_TTY=
    echo "a" > "1.txt"
    echo "a" > "2.txt"
    echo "a" > "3.txt"
    capture_output sorted kbg a < <(printf '%s\n%s' "1.txt" "2.txt")
    assert_no_stderr
    assert_stdout '^1\.txt
2\.txt$'
    assert_exit_code 0
}

@test 'stdin - empty (ANY) - returns nothing' {
    export KBGREP_ASSUME_TTY=
    echo "a" > a.txt
    capture_output kbg --any a < /dev/null
    assert_no_stderr
    assert_no_stdout
    assert_exit_code 0
}

@test 'stdin - contains file paths (ANY) - searches only those files' {
    export KBGREP_ASSUME_TTY=
    echo "a" > "1.txt"
    echo "a" > "2.txt"
    echo "a" > "3.txt"
    capture_output sorted kbg --any a < <(printf '%s\n%s' "1.txt" "2.txt")
    assert_no_stderr
    assert_stdout '^1\.txt
2\.txt$'
    assert_exit_code 0
}
