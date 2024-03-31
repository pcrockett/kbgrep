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
    if [ ${#} -gt 0 ]; then
        local current="${1}"
        shift
        eval "${current}" | exec_pipeline "${@}"
    else
        cat
    fi
}
