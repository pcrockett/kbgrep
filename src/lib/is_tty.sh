# shellcheck shell=bash

is_tty() {
  tty --quiet || [ "${KBGREP_ASSUME_TTY:-}" != "" ]
}
