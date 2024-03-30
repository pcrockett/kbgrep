# shellcheck shell=bash

panic() {
    echo "${*}" >&2
    exit 1
}
