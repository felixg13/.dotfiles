#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Source .bash_aliases if it exists
if [ -f "$HOME/.bash_aliases" ]; then
    . "$HOME/.bash_aliases"
fi

# only run in distrobox
if [ -n "$DISTROBOX_ENTER_PATH" ]; then
    if [ -f "$HOME/git-poly/inf3995/.bashrc_ros2" ]; then
        . $HOME/git-poly/inf3995/.bashrc_ros2
        echo "Configured ROS2 env: ${ROS_DISTRO}"
        return 0
    fi
fi

# Source the ROS env or not
export RUN_WITH_ROS=false

if [[ "${RUN_WITH_ROS}" == "true" ]]; then
    source /opt/ros/jazzy/setup.bash
    export ROS_VERSION=2
    export ROS_PYTHON_VERSION=3
    export ROS_DISTRO=jazzy
    export ROS_DOMAIN_ID=42
    echo "Sourced the ROS env"
fi
if [ "$TERM" = "xterm-kitty" ]; then
    eval "$(starship init bash)"
fi

# Go libs
export PATH="$PATH:$(go env GOBIN):$(go env GOPATH)/bin"
