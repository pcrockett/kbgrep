# shellcheck shell=bash

if [ "${KBG_DEBUG:-}" = "true" ]; then
    inspect_args >&2
fi

rg_options=(
    --fixed-strings
    --files-with-matches
)

fzf_cmd="fzf --multi"

eval "terms=(${args[term]})"

if [ "${args[--or]:-}" != "" ]; then
    # find files with ANY term. easy case, `rg` supports this natively.

    if [ "${args[--type]}" != "" ]; then
        rg_options+=(--type "${args[--type]}")
    fi

    rg_command=(rg "${rg_options[@]}")

    for t in "${terms[@]}"; do
        escaped_term="$(printf "%q" "${t}")"
        # shellcheck disable=SC2206  # intentionally leaving ${escaped_term} unquoted: string splitting not a concern because it's escaped.
        rg_command+=(--regexp ${escaped_term})
    done

    pipeline=("${rg_command[*]}")

    if [ "${args[--select]}" != "" ]; then
        pipeline+=("${fzf_cmd}")
    fi

    exec_pipeline "${pipeline[@]}"
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
    pipeline=()
    for t in "${terms[@]}"; do
        escaped_term="$(printf "%q" "${t}")"
        # shellcheck disable=SC2206  # intentionally leaving ${escaped_term} unquoted: string splitting not a concern because it's escaped.
        filter_cmd=(xargs rg "${rg_options[@]}" ${escaped_term})
        pipeline+=("${filter_cmd[*]}")
    done

    files_cmd=(rg --files)
    if [ "${args[--type]}" != "" ]; then
        files_cmd+=(--type "${args[--type]}")
    fi

    if [ "${args[--select]}" != "" ]; then
        pipeline+=("${fzf_cmd}")
    fi

    "${files_cmd[@]}" | exec_pipeline "${pipeline[@]}"
fi

