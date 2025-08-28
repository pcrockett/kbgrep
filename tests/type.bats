#!/usr/bin/env bats
# shellcheck disable=SC2030,2031  # exported env vars only take effect inside a test

source tests/util.sh

@test 'type - none specified - returns all files' {
  echo "a" >foo.md
  echo "a" >foo.py
  echo "a" >foo.sh
  echo "a" >foo.txt

  capture_output sorted kbg a
  assert_no_stderr
  assert_stdout '^foo\.md
foo\.py
foo\.sh
foo\.txt$'
  assert_exit_code 0
}

@test 'type - none specified (ANY) - returns all files' {
  echo "a" >foo.md
  echo "a" >foo.py
  echo "a" >foo.sh
  echo "a" >foo.txt

  capture_output sorted kbg --any a
  assert_no_stderr
  assert_stdout '^foo\.md
foo\.py
foo\.sh
foo\.txt$'
  assert_exit_code 0
}

@test 'type - markdown specified - returns md files' {
  echo "a" >foo.md
  echo "a" >foo.py
  echo "a" >foo.sh
  echo "a" >foo.txt

  capture_output kbg --type markdown a
  assert_no_stderr
  assert_stdout '^foo\.md$'
  assert_exit_code 0
}

@test 'type - markdown specified (ANY) - returns md files' {
  echo "a" >foo.md
  echo "a" >foo.py
  echo "a" >foo.sh
  echo "a" >foo.txt

  capture_output kbg --type markdown --any a
  assert_no_stderr
  assert_stdout '^foo\.md$'
  assert_exit_code 0
}

@test 'type - no terms specified - returns list of files' {
  echo "a" >foo.md
  echo "a" >bar.md
  echo "a" >foo.py
  echo "a" >foo.sh
  echo "a" >foo.txt

  capture_output sorted kbg --type markdown
  assert_no_stderr
  assert_stdout '^bar\.md
foo\.md$'
  assert_exit_code 0
}

@test 'type - while in interactive mode - returns list of files' {
  export KBGREP_INTERACTIVE=1
  echo "a" >a.md
  echo "b" >b.txt

  capture_output kbg --type markdown < <(echo "this should be discarded")
  assert_no_stderr
  assert_stdout '^a\.md$'
  assert_exit_code 0
}

@test 'type - while in interactive mode (ANY) - returns list of files' {
  export KBGREP_INTERACTIVE=1
  echo "a" >foo.md
  echo "a" >foo.txt

  capture_output kbg --type markdown --any a < <(echo "this should be discarded")
  assert_no_stderr
  assert_stdout '^foo\.md$'
  assert_exit_code 0
}
