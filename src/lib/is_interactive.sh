# shellcheck shell=bash

is_interactive() {
    test "${KBGREP_INTERACTIVE:-}" != ""
}
