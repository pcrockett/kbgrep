#!/usr/bin/env bats
# shellcheck disable=SC2030,SC2031  # exported variables are only good inside a given test

source tests/util.sh

assert_mock_args() {
  while [[ ${#} -gt 0 ]]; do
    assert_stderr "[[:space:]]arg=${1}[[:space:]]"
    shift
  done
}

@test 'interactive - no args provided - runs fzf' {
  echo "a" >a.txt

  # tell our fzf mock to output "a.txt" -- simulating a user that selected "a.txt"
  export MOCK_STDOUT="a.txt"

  capture_output kbg

  assert_stderr '^program_name=fzf[[:space:]]'

  # shellcheck disable=SC2016  # i want my dollar signs to be literal
  assert_mock_args --preview 'bat\\ .+' \
    --preview-window 'up\\,.+' \
    --bind "change:reload.+" "ctrl-r:reload.+" "ctrl-d:execute.+"

  assert_stderr '.*stdin=$'

  assert_stdout '^a\.txt$'
  assert_exit_code 0
}
