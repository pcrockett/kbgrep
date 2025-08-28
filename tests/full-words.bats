#!/usr/bin/env bats

source tests/util.sh

@test 'full words - flag omitted - returns partial matches' {
  echo "hello foobar whatever" >test.txt
  capture_output kbg foo
  assert_no_stderr
  assert_stdout '^test\.txt$'
  assert_exit_code 0
}

@test 'full words - flag included - returns only full matches' {
  echo "hello foobar whatever" >test.txt
  capture_output kbg --full-words foo
  assert_no_stderr
  assert_no_stdout
  assert_exit_code 1

  echo "hello foobar whatever" >test.txt
  capture_output kbg --full-words foobar
  assert_no_stderr
  assert_stdout '^test\.txt$'
  assert_exit_code 0
}
