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
    #
    # given search terms "foo" and "bar", we will effectively construct the following pipeline:
    #
    #     rg --files \
    #         | xargs rg foo \
    #         | xargs rg bar
    #
    # ...but we'll do it dynamically with `exec_pipeline`
    filters=()
    for t in "${terms[@]}"; do
        escaped_term="$(printf "%q" "${t}")"
        # shellcheck disable=SC2206  # intentionally leaving ${escaped_term} unquoted: string splitting not a concern because it's escaped.
        filter_cmd=(xargs rg --fixed-strings --files-with-matches ${escaped_term})
        filters+=("${filter_cmd[*]}")
    done
    rg --files | exec_pipeline "${filters[@]}"
fi

