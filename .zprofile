# ln -s ~/Documents/work/dotfiles.public/.zprofile /Users/palanikannan/.zprofile
# export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-17.0.3.1.jdk/Contents/Home"

# Setting PATH for Python 3.10
# The original version is saved in .zprofile.pysave
PATH="/usr/local/bin:${PATH}"

# pnpm
export PNPM_HOME="/Users/palanikannan/Library/pnpm"
PATH="$PNPM_HOME:$PATH"
# pnpm end

PATH="$PATH:$HOME/.tmux/plugins/tmuxifier/bin"
export PATH="$PATH:/Users/palanikannan/.npm-global/bin:/Users/palanikannan/bin"
# export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
