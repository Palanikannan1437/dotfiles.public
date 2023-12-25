#!/bin/zsh
# ln -s ~/Documents/work/dotfiles.public/.config/lazygit/ai_commit.sh /Users/palanikannan/

# Define a function to fetch and export the OPENAI_API_KEY
fetch_openai_key() {
	export OPENAI_API_KEY=$(op item get OPENAI_API_KEY --fields=credential)
}

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
		ai-commitss
	else
		echo "Failed to fetch OPENAI_API_KEY. Cannot execute ai-commit."
	fi
}

# Call the ai_commit function
ai_commit
