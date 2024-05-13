# shellcheck shell=bash

if [ "${#args[@]}" -eq 0 ] && [ "${#other_args[@]}" -eq 0 ] && ! is_interactive; then

    kbg_command="${0}"
    search_result_command="${EDITOR:-echo}"
    bat_pager="less --RAW-CONTROL-CHARS --quiet --ignore-case"

    export KBGREP_INTERACTIVE=1

    FZF_DEFAULT_COMMAND="${kbg_command}" \
        SHELL=sh \
        fzf --ansi \
            --disabled \
            --bind "change:reload(echo {q} | xargs ${kbg_command} || true)" \
            --bind "ctrl-r:reload(echo {q} | xargs ${kbg_command} || true)" \
            --bind "ctrl-d:execute(bat --color=always --wrap never --pager '${bat_pager}' {})" \
            --preview "bat --color=always --terminal-width \${FZF_PREVIEW_COLUMNS} --wrap never --paging never {}" \
            --preview-window 'up,70%,border-bottom,+{2}+3/3,~3' \
            --bind "enter:become(${search_result_command} {})"

    exit 0
fi

if is_interactive; then
    # handle interactive mode special cases

    if [ "${args[--edit]:-}" != "" ]; then
        # the user typed --edit in as a search query; treat it as a search term.
        # we don't want to launch the $EDITOR on every keystroke...
        unset "args[--edit]"
        other_args+=("--edit")
    fi
fi

rg_options=(
    --fixed-strings
    --files-with-matches
    --ignore-case
)

if [ "${args[--full-words]:-}" != "" ]; then
    rg_options+=(--word-regexp)
fi

terms=("${other_args[@]}")

if [ "${args[--edit]:-}" != "" ] && [ "${EDITOR:-}" = "" ]; then
    # shellcheck disable=SC2016  # i want a literal dollar sign
    panic '$EDITOR environment variable is not defined.'
fi

if [ "${args[--any]:-}" != "" ]; then
    # find files with ANY term. easy case, `rg` supports this natively.

    if [ ${#terms[@]} -eq 0 ]; then
        panic "Must supply search terms with \`--any\`"
    fi

    if [ "${args[--type]:-}" != "" ]; then
        rg_options+=(--type "${args[--type]}")
    fi

    if is_interactive || is_tty; then
        # either one of these cases may be true:
        #
        # * a tty is connected to stdin
        # * this is being run from the fzf interactive UI
        #
        # in either case, we're not getting a file list from stdin; we will
        # let ripgrep handle that.
        rg_command=(rg "${rg_options[@]}")
    else
        # a file list is coming from stdin. xargs those files to the ripgrep command.
        rg_command=(xargs_newline --no-run-if-empty rg "${rg_options[@]}")
    fi

    for t in "${terms[@]}"; do
        escaped_term="$(printf "%q" "${t}")"
        # shellcheck disable=SC2206  # intentionally leaving ${escaped_term} unquoted: string splitting not a concern because it's escaped.
        rg_command+=(--regexp ${escaped_term})
    done

    pipeline=("${rg_command[*]}")

    if [ "${args[--edit]:-}" != "" ]; then
        readarray -t files_to_edit < <(exec_pipeline "${pipeline[@]}")
        if [ ${#files_to_edit[@]} -gt 0 ]; then
            exec ${EDITOR} "${files_to_edit[@]}"
        else
            exit 1
        fi
    else
        exec_pipeline "${pipeline[@]}"
    fi

else
    # find files with ALL terms. difficult case, need to pipeline multiple `rg` invocations.
    #
    # given search terms "foo" and "bar", we will effectively construct the following
    # (oversimplified) pipeline:
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
        filter_cmd=(xargs_newline --no-run-if-empty rg "${rg_options[@]}" --regexp ${escaped_term})
        pipeline+=("${filter_cmd[*]}")
    done

    if is_interactive || is_tty; then
        # either one of these cases may be true:
        #
        # * a tty is connected to stdin
        # * this is being run from the fzf interactive UI
        #
        # in either case, we're not getting a file list from stdin; we need
        # to generate the file list ourselves.
        files_cmd=(rg --files)
        if [ "${args[--type]:-}" != "" ]; then
            files_cmd+=(--type "${args[--type]}")
        fi
        pipeline=("${files_cmd[*]}" "${pipeline[@]}")
    fi

    if [ "${args[--edit]:-}" != "" ]; then
        readarray -t files_to_edit < <(exec_pipeline "${pipeline[@]}")
        if [ ${#files_to_edit[@]} -gt 0 ]; then
            exec ${EDITOR} "${files_to_edit[@]}"
        else
            exit 1
        fi
    else
        exec_pipeline "${pipeline[@]}"
    fi
fi

