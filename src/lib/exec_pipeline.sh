# shellcheck shell=bash

exec_pipeline() {
    # execute a list of commands, piping their output from one to the next. allows you to
    # dynamically build a pipeline of commands at runtime.
    #
    # example usage:
    #
    #     echo "foo bar" | exec_pipeline \
    #         'cut --delimiter " " --fields 2' \
    #         'tr "[:lower:]" "[:upper:]"'
    #
    # this is the same as running:
    #
    #     echo "foo bar" | cut --delimiter " " --fields 2 | tr "[:lower:]" "[:upper:]"
    #
    # and outputs:
    #
    #     BAR
    #
    # thanks to <https://stackoverflow.com/a/63981571/138757> for the idea
    if is_interactive; then
        # we aren't expecting stdin. if there is any data on stdin, we should ignore it.
        __exec_pipeline "${@}" < /dev/null
    else
        __exec_pipeline "${@}"
    fi
}

__exec_pipeline() {
    if [ ${#} -gt 0 ]; then
        local current="${1}"
        shift
        eval "${current}" | __exec_pipeline "${@}"
    else
        cat
    fi
}
