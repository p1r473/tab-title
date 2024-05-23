update_window_title() {
	username=$(whoami)
	hostname=$(hostname)
	local dir="$1"
	local cmd="$2"

	# Truncate directory to 20 characters
	local truncated_dir=$(print -P "%20<..<${dir}")
	local truncated_title="$truncated_dir"

	if [ -n "$cmd" ]; then
	    truncated_title="$truncated_dir - $cmd"
	    pane_content="$username@$hostname - $dir - $cmd"
	else
	    pane_content="$username@$hostname - $dir"
	fi

	printf "\033k%s\033\\" "$truncated_title"
	printf "\033]2;%s\033\\" "$pane_content"
	printf "\033]0;%s\033\\" "$pane_content"
	if [ -n "$TMUX" ]; then
	    tmux rename-window "$truncated_title"
	fi
}

# Set up hooks for changing directory and executing commands
autoload -Uz add-zsh-hook

# Function to update window title when changing directories
chpwd_title_update() {
    local current_dir=$(print -P "%~")
    update_window_title "$current_dir"
}

# Function to capture the command and update title before execution
preexec_title_update() {
    local cmd_first_part=${1[(w)1]}
    local current_dir=$(print -P "%~")
    update_window_title "$current_dir" "$cmd_first_part"
}

# Function to reset the window title after command finishes
precmd_title_update() {
    local current_dir=$(print -P "%~")
    update_window_title "$current_dir"
}

# Attach functions to Zsh hooks
add-zsh-hook chpwd chpwd_title_update
add-zsh-hook preexec preexec_title_update
add-zsh-hook precmd precmd_title_update
