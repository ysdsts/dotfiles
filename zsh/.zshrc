export XDG_CONFIG_HOME="$HOME/.config"

if command -v fastfetch &> /dev/null; then
	if [ ${SHLVL} -eq 1 ]; then
		fastfetch
	fi
fi

FPATH=/opt/homebrew/share/zsh-completions:$FPATH
FPATH=/opt/homebrew/share/zsh/site-functions:$FPATH

autoload -Uz compinit
compinit

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

if [[ $(command -v eza) ]]; then
	alias ei="eza --icons --git"
	alias ea="eza -a --icons --git"
	alias ee="eza -bghHlia --time-style='long-iso' --icons --git"
	alias et="eza -T -L 3 -a -I 'node_modules|.git|.cache' --icons"
	alias eta="eza -T -a -I 'node_modules|.git|.cache' --color=always --icons | less -r"
	alias ls=ei
	alias la=ea
	alias ll=ee
	alias lt=et
	alias lta=eta
	alias l="clear && ls"
fi

source <(fzf --zsh)

# eval "$(zoxide init zsh --cmd cd)"
eval "$(zoxide init zsh)"
export _ZO_FZF_OPTS='
    --no-sort --height 75% --reverse --margin=0,1 --exit-0 --select-1
    --bind ctrl-f:page-down,ctrl-b:page-up
    --bind pgdn:preview-page-down,pgup:preview-page-up
    --prompt="❯ "
    --color bg+:#262626,fg+:#dadada,hl:#f09479,hl+:#f09479
    --color border:#303030,info:#cfcfb0,header:#80a0ff,spinner:#36c692
    --color prompt:#87afff,pointer:#ff5189,marker:#f09479
    --preview "([[ -e '{2..}/README.md' ]] && bat --color=always --style=numbers --line-range=:50 '{2..}/README.md') || eza --color=always --group-directories-first --oneline {2..}"
'
export FZF_CTRL_R_OPTS="
    --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
    --color header:italic
    --header 'Press CTRL-Y to copy command into clipboard'"

export FZF_CTRL_T_OPTS="
    --walker-skip .git,node_modules,target
    --preview 'bat -n --color=always {}'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_ALT_C_OPTS="
    --walker-skip .git,node_modules,target
    --preview 'tree -C {}'"

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval "$(starship init zsh)"

alias ghostty-opacity='~/.config/ghostty/toggle_opacity.sh'

