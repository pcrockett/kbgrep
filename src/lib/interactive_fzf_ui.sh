# shellcheck shell=bash

interactive_fzf_ui() {
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
    --bind "ctrl-d:execute(bat --color=always --wrap never --pager '${bat_pager}' --plain {})" \
    --preview "bat --color=always --terminal-width \${FZF_PREVIEW_COLUMNS} --wrap never --paging never --plain {}" \
    --preview-window 'up,70%,border-bottom,+{2}+3/3,~3' \
    --bind "enter:become(${search_result_command} {})"
}
