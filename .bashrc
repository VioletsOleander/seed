# Functions

function path_prepend() {
    case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
    esac
}

function path_append() {
    case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$PATH:$1" ;;
    esac
}

# Env

path_prepend "~/.cargo/bin"
path_prepend "~/.local/bin"

export EDITOR=nvim
export MANPAGER="nvim -c Man!"

if [[ -d /home/linuxbrew/.linuxbrew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
fi

# Alias

alias ls="ls --color=auto"
alias la="ls --all"
alias ll="ls --all -l"

alias grep="grep --color=auto"

alias df="df --human-readable"
alias du="du --human-readable"

alias cls=clear
alias vi=vim
alias nv=nvim

# Integrations

# bash-completion
if [[ $PS1 &&
    ! ${BASH_COMPLETION_VERSINFO:-} &&
    -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi

# zoxide
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
fi

# fzf
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --bash)"
fi

# Functions

function proxy_on() {
    local proxy_file="~/.config/proxy.txt"

    if [[! -f "$proxy_file"]]; then
        echo Error: failed to find $proxy_file
        return 1
    fi

    local proxy_url="(cat $proxy_file)"

    export http_proxy="http://$proxy_url"
    export https_proxy="http://$proxy_url"
    export all_proxy="socks5://$proxy_url"
    echo "Proxy has been set to $proxy_url"

    proxy_status
}

function proxy_off() {
    unset http_proxy
    unset https_proxy
    unset all_proxy
    echo "Proxy has been disabled."
}

function proxy_status() {
    echo "http_proxy  = $http_proxy"
    echo "https_proxy = $https_proxy"
    echo "all_proxy   = $all_proxy"
}
