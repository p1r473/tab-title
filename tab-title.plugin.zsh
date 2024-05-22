update_window_title() {
    local title_content="$1"
    if [[ -n "$2" ]]; then
        title_content="$title_content $2"  # Append command if provided
    fi

    if [ -n "$STY" ] || [ -n "$SCREEN" ]; then
        # Screen
        print -Pn "\ek$title_content\e\\"
    elif [ -n "$TMUX" ]; then
        # Tmux 
	print -Pn "\033]2;$title_content\033\\"    
        print -Pn "\033k$title_content\033\\"  # Set tmux window name
        print -Pn "\033]0;$title_content\033\\" # Set terminal title (xterm compatible)
        tmux rename-window "$title_content"
    fi
}

# Set up hooks for changing directory and executing commands
autoload -Uz add-zsh-hook

# Function to update window title when changing directories
chpwd_title_update() {
    local current_dir=$(print -P "%15<..<%~")  # Truncated current directory
    update_window_title "$current_dir"
}

# Function to capture the command and update title before execution
preexec_title_update() {
    local cmd_first_part=${1[(w)1]}  # Store the first word of the command
    local current_dir=$(print -P "%15<..<%~")  # Truncated current directory
    update_window_title "$current_dir" "$cmd_first_part"
}

# Function to reset the window title after command finishes
precmd_title_update() {
    local current_dir=$(print -P "%15<..<%~")  # Truncated current directory
    update_window_title "$current_dir"
}

# Attach functions to Zsh hooks
add-zsh-hook chpwd chpwd_title_update
add-zsh-hook preexec preexec_title_update
add-zsh-hook precmd precmd_title_update
