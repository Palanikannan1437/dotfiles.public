# linkage --> ln -s ~/Documents/work/dotfiles.public/.zshrc /Users/palanikannan/.zshrc
export ZSH="$HOME/.oh-my-zsh"

. $HOME/.asdf/asdf.sh

#oh-my-zsh plugins
plugins=(
	zsh-autosuggestions          #for autocompletion suggestion from history
	zsh-syntax-highlighting      #for basic syntax highlighting
	zsh-history-substring-search #for searching using a keyword from the history using up and down arrows
)

source $ZSH/oh-my-zsh.sh

# tmux-sessionizer
bindkey -s ^f "tmux-sessionizer\n"
bindkey -s ^v "vi .\n"
bindkey -s ^a "tmux a"

# Define a function to fetch and export the OPENAI_API_KEY from 1password
fetch_openai_key() {
	export OPENAI_API_KEY=$(op item get OPENAI_API_KEY --fields=credential)
}

# Bind the function to a key combination, for example, Ctrl+o
bindkey -s '^o' 'fetch_openai_key\n'

# Bind for ai-commit
bindkey -s '^n' 'ai_commit\n'

# Define your ai-commit function
ai_commit() {
	# Check if OPENAI_API_KEY is set and non-empty
	if [[ -z "${OPENAI_API_KEY}" ]]; then
		# If OPENAI_API_KEY is not set or is empty, fetch it
		fetch_openai_key
	fi

	# Check again if OPENAI_API_KEY is set and non-empty
	if [[ -n "${OPENAI_API_KEY}" ]]; then
		# If OPENAI_API_KEY is now set, execute ai-commit
		ai-commit
	else
		echo "Failed to fetch OPENAI_API_KEY. Cannot execute ai-commit."
	fi
}

# history-substring-search options
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# pretty prompt
eval "$(starship init zsh)"

#alias for vim
alias vi="nvim"
alias vim="nvim"

# config tmuxifier for automated tmux sessions startups
eval "$(tmuxifier init -)"
export EDITOR=nvim

export FZF_DEFAULT_COMMAND="fd . $HOME/Documents/work\n"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse-list --border'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export GPG_TTY=$(tty)

eval "$(zoxide init zsh)"
