###############################################
# 1. Load environment-specific overrides
###############################################
if [[ -f ~/.bashrc.work ]]; then
    . ~/.bashrc.work
elif [[ -f ~/.bashrc.home ]]; then
    . ~/.bashrc.home
fi


###############################################
# 2. Core shell behavior (must always work)
###############################################

# Editor + vi mode
export EDITOR=/usr/bin/vi
set -o vi

# update $COLUMNS on resize
shopt -s checkwinsize


# History settings
HISTSIZE=100000
HISTFILESIZE=100000
HISTCONTROL=ignoreboth
HISTTIMEFORMAT='%F %T '
shopt -s histappend
PROMPT_COMMAND='history -a; history -n'


###############################################
# 3. Utility functions
###############################################

# Full-width separator line
line() {
    local cols=${COLUMNS:-$(tput cols)}
    printf '─%.0s' $(seq 1 "$cols")
    printf '\n'
}

# Git branch (home only)
git_branch() {
    # Only show git info when NOT in work mode
    if [[ -n "$WORK_ENV" ]]; then
        return
    fi

    command -v git >/dev/null 2>&1 || return
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    [[ -n "$branch" ]] && printf " (git:%s)" "$branch"
}

# Host color logic
host_color() {
    if [[ -z "$WORK_ENV" ]]; then
        # Home mode
        if [[ -z "$SSH_CLIENT" ]]; then
            printf '\[\e[1;34m\]'   # blue local
        else
            printf '\[\e[1;35m\]'   # magenta SSH
        fi
    else
        # Work mode overrides
        case "$SERVER_ROLE" in
            prod) printf '\[\e[1;31m\]' ;;  # red
            test) printf '\[\e[1;32m\]' ;;  # green
            *)    printf '\[\e[1;34m\]' ;;  # fallback blue
        esac
    fi
}


###############################################
# 4. Prompt setup
###############################################
build_prompt() {
    PS1="$(line)[\d \A] \[\e[0;36m\]\w\[\e[m\]$(git_branch)\n"
    if [[ $last_status -ne 0 ]]; then
        PS1+="\[\e[1;31m\]($last_status)\[\e[m\] "
    fi
    PS1+="[\u@$(host_color)\h\[\e[m\] #\!]\$ "
}
PROMPT_COMMAND='last_status=$?; build_prompt'
