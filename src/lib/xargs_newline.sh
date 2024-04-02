# shellcheck shell=bash

xargs_newline() {
    # same as xargs, but explicitly specify the newline character as delimiter
    xargs --delimiter '\n' "${@}"
}
