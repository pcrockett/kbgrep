#!/usr/bin/env bash
set -Eeuo pipefail

# this is designed to help you mock out a system dependency.
#
# ex: rename this to `fzf` and make sure it's listed earlier in the $PATH variable than the _actual_
# `fzf` executable. then you can inspect the inputs that were passed to `fzf` without actually
# running `fzf`.

log_stderr() {
    echo "${*}" >&2
}

log_stderr "program_name=$(basename "${0}")"
for arg in "${@}"; do
    escaped_arg="$(printf '%q' "${arg}")"
    log_stderr "arg=${escaped_arg}"
done

if tty --quiet; then
    log_stderr "stdin="
else
    log_stderr "stdin=$(cat)"
fi

test -v MOCK_STDOUT && echo "${MOCK_STDOUT}"

if [ "${MOCK_EXIT_CODE:-}" = "" ]; then
    exit 0
else
    exit "${MOCK_EXIT_CODE}"
fi
