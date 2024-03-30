# shellcheck shell=bash

if [ "${KBG_DEBUG:-}" = "true" ]; then
    inspect_args >&2
fi

eval "terms=(${args[term]})"


if [ "${args[--or]:-}" != "" ]; then
    # find files with ANY term. easy case, `rg` supports this natively.
    rg_command=(rg --fixed-strings --files-with-matches)
    for t in "${terms[@]}"; do
        rg_command+=(--regexp "${t}")
    done
    "${rg_command[@]}"
else
    # find files with ALL terms. difficult case, need to pipeline multiple `rg` invocations.
    exec_filters() {
        # thanks to <https://stackoverflow.com/a/63981571/138757> for the idea
        if [ ${#} -gt 0 ]; then
            local current="${1}"
            shift
            eval "${current}" | exec_filters "${@}"
        else
            cat
        fi
    }

    filters=()
    for t in "${terms[@]}"; do
        escaped_term="$(printf "%q" "${t}")"
        filter_cmd=(xargs rg --fixed-strings --files-with-matches "${escaped_term}")
        filters+=("${filter_cmd[*]}")
    done
    rg --files | exec_filters "${filters[@]}"
fi

