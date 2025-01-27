#
# ~/.bash_profile
#
if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]] && uwsm check may-start; then
    exec uwsm start hyprland.desktop
fi
[[ -f ~/.bashrc ]] && . ~/.bashrc
