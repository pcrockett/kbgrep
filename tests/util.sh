# shellcheck shell=bash

setup() {
    set -Eeuo pipefail
    TEST_CWD="$(mktemp --directory --tmpdir=/tmp kbgrep-test.XXXXXX)"
    TEST_HOME="$(mktemp --directory --tmpdir=/tmp kbgrep-home.XXXXXX)"
    mkdir -p "${TEST_HOME}/.local/bin"
    cp kbg "${TEST_HOME}/.local/bin"
    cp tests/mock.sh "${TEST_HOME}/.local/bin/fzf"
    cp .tool-versions "${TEST_CWD}"
    cd "${TEST_CWD}"
    PATH="${TEST_HOME}/.local/bin:${PATH}"
    export HOME="${TEST_HOME}"
}

teardown() {
    rm -rf "${TEST_CWD}"
    rm -rf "${TEST_HOME}"
}

fail() {
    echo "${*}"
    exit 1
}

sorted() {
    # run a command and sort its output
    #
    # example usage:
    #
    #     sorted printf '%s\n%s\n%s\n' c b a
    #
    # outputs:
    #
    #     a
    #     b
    #     c
    #
    # i would use the GNU coreutils 'sort', however that doesn't
    # sort reliably on all linux distros. ruby will do it better.
    "${@}" | ruby <(echo 'STDIN.readlines.map(&:chomp).sort.each { |line| puts line }')
}

# shellcheck disable=SC2034  # this function returns data via variables
capture_output() {
    local stderr_file stdout_file
    stderr_file="$(mktemp)"
    stdout_file="$(mktemp)"
    capture_exit_code "${@}" \
        > "${stdout_file}" \
        2> "${stderr_file}"
    TEST_STDOUT="$(cat "${stdout_file}")"
    TEST_STDERR="$(cat "${stderr_file}")"
    rm -f "${stdout_file}" "${stderr_file}"
}

# shellcheck disable=SC2034  # this function returns data via variables
capture_exit_code() {
    if "${@}"; then
        TEST_EXIT_CODE=0
    else
        TEST_EXIT_CODE=$?
    fi
}

assert_exit_code() {
    test "${TEST_EXIT_CODE}" -eq "${1}" \
        || fail "Expected exit code ${1}; got ${TEST_EXIT_CODE}"
}

assert_stdout() {
    if ! [[ "${TEST_STDOUT}" =~ ${1} ]]; then
        printf "******STDOUT:******\n%s\n*******************\n" "${TEST_STDOUT}"
        printf "*****EXPECTED:*****\n%s\n*******************\n" "${1}"
        fail "stdout didn't match expected."
    fi
}

assert_no_stdout() {
    if [ "${TEST_STDOUT}" != "" ]; then
        printf "******STDOUT:******\n%s\n*******************\n" "${TEST_STDOUT}"
        fail "stdout is expected to be empty."
    fi
}

assert_stderr() {
    if ! [[ "${TEST_STDERR}" =~ ${1} ]]; then
        printf "******STDERR:******\n%s\n*******************\n" "${TEST_STDERR}"
        printf "*****EXPECTED:*****\n%s\n*******************\n" "${1}"
        fail "stderr didn't match expected."
    fi
}

assert_no_stderr() {
    if [ "${TEST_STDERR}" != "" ]; then
        printf "******STDERR:******\n%s\n*******************\n" "${TEST_STDERR}"
        fail "stderr is expected to be empty."
    fi
}
