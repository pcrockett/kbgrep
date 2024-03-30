# shellcheck shell=bash
# shellcheck disable=SC2154  # we use variables that will be defined after bashly runs

if [ "${KBG_DEBUG:-}" = "true" ]; then
    inspect_args >&2
fi

eval "terms=(${args[term]})"

rg_command=(rg --fixed-strings --files-with-matches)

for t in "${terms[@]}"; do
    rg_command+=(--regexp "${t}")
done

"${rg_command[@]}"
