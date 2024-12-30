# Aide mémoire pour configurer mon système avec Arch et Hyprland

## Dependencies and Environment

### Environment

First I should update all packages to most recent versions:

```bash
sudo pacman -Syu
```

I like to add 3 important directories to my home folder:

- git (for git projects)
- poly-git (for school git projects)
- git-Downloads (to build package from source trough git)

We will make the directories and make aliases navigate quickly

```bash
mkdir -p ~/git ~/poly-git ~/git-Downloads
```

### Git

Install git and the with pacman

```bash
sudo pacman -Syu git
```

[Git Arch page](https://wiki.archlinux.org/title/Git)

#### github-cli

I use the github cli to set up ssh keys and clone this repo

```bash
sudo pacman -Syu github-cli

gh auth login
# TEST with:
gh auth status
```

### ssh

I want to access the github .dotfiles repo with ssh

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f "~/.ssh/id_rsa_github_perso"
ssh-add ~/.ssh/id_rsa_github_perso
gh ssh-key add ~/.ssh/id_rsa_personal_github.pub --title "MACHINE_DESCRIPTION"
# TEST with
ssh -T git@github.com
```

I should be able to see my repos with

```bash
gh repo list
```

### .dotfiles repo

Clone the dotfiles repo in the git directory using gh or git.

```bash
gh repo clone .dotfiles ~/git/
git clone git@github.com:felixg13/.dotfiles.git ~/git/
```

### Dependencies and Environement Summary

you can run this bash script to execute this section at once:

```bash
#!/usr/bin/env bash

# Update packages
sudo pacman -Syu

# Create essential directories
mkdir -p ~/git ~/poly-git ~/git-Downloads

# Install Git and GitHub CLI
sudo pacman -Syu git github-cli

# Authenticate GitHub CLI
gh auth login
gh auth status

# Generate SSH key and add to GitHub
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f "~/.ssh/id_rsa_github_perso"
ssh-add ~/.ssh/id_rsa_github_perso
gh ssh-key add ~/.ssh/id_rsa_personal_github.pub --title "MACHINE_DESCRIPTION"
ssh -T git@github.com
gh repo list

# Clone .dotfiles repo
gh repo clone .dotfiles ~/git/
git clone git@github.com:felixg13/.dotfiles.git ~/git/
```

## Yay

```bash
cd ~/git-Downloads
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

[yay README](https://github.com/Jguer/yay)

## pipewire

```bash
yay -S pipewire pipewire-docs wireplumber
sudo systemctl --user enable pipewire
sudo systemctl --user start pipewire
sudo systemctl --user status pipewire
```

## Gtk, Icons, cursor and font

```bash
yay -S gruvbox-gtk-theme-git gruvbox-material-icon-theme-git ttf-jetbrains-mono-git
gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Gruvbox-Material-Dark'
gsettings set org.gnome.desktop.interface font-name 'JetBrains Mono Nerd Font 11'
# Utilities to manipulate gtk theme
yay -S dconf-editor ngw-look
```

### Sumary of yay, audioServer, themes

```bash
#!/usr/bin/env bash

# Install Yay
cd ~/git-Downloads
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Install Pipewire
yay -S pipewire pipewire-docs wireplumber \\
gruvbox-gtk-theme-git gruvbox-material-icon-theme-git ttf-jetbrains-mono-git \\
dconf-editor ngw-look
gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Gruvbox-Material-Dark'
gsettings set org.gnome.desktop.interface font-name 'JetBrains Mono Nerd Font 11'
sudo systemctl --user enable pipewire
sudo systemctl --user start pipewire
sudo systemctl --user status pipewire

```

## Hyprland

```bash
yay -S hyprland-git
```

linking the configuration to the .config directory:

```bash
ln -sf "$(pwd)" "${XDG_CONFIG_HOME:-$HOME/.config}/hypr"
```

[Hyprland installation](https://wiki.hyprland.org/Getting-Started/Installation/)

### Background

```bash
yay -S hyprpaper-git
```

### Lockscreen

```bash
yay -S hyprlock-git
```

[config source is this redit thread](https://www.reddit.com/r/unixporn/comments/1dhzu7y/how_is_my_hyprlock_hyprland/)

### Idle deamon

```bash
yay -S hypridle-git
```

### Notifications

```bash
yay -S swaync
```

### Screenshots

```bash
yay -S hyprshot
```

### clipboard manager

```bash
yay -S cliphist
```

[Clipboard Manager Hyprland Wiki page](https://wiki.hyprland.org/Useful-Utilities/Clipboard-Managers/)

### Autologin and session manager

Using getty to autologin on boot

```.conf
/etc/systemd/system/getty@tty1.service.d/autologin.conf

[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin username %I $TERM
```

[Getty Arch wiki](https://wiki.archlinux.org/title/Getty)

Using Universal wayland session manager as a lightweight manager

```bash
yay -S uwsm
```

```bash
# .bash_profile

if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]] && uwsm check may-start; then
    exec uwsm start hyprland.desktop
fi
```

[uwsm hyprland wiki page](https://wiki.hyprland.org/Useful-Utilities/Systemd-start/)

### Status Bar

```bash
yay -S waybar-git
ln -sf "$(pwd)/waybar" "${XDG_CONFIG_HOME:-$HOME/.config}/waybar"
```

### App launcher

```bash
yay -S wofi
ln -sf "$(pwd)/wofi" "${XDG_CONFIG_HOME:-$HOME/.config}/wofi"
```

### logout

``` bash
yay -S wlogout
ln -sf "$(pwd)/wlogout" "${XDG_CONFIG_HOME:-$HOME/.config}/wlogout"
```

### polkit

```bash
yay -S hyprpolkitagent-git
```

### summary

Seperating each aspect of the hyprland configuration,
but a unique yay command is also possible

```bash
#!/usr/bin/env bash

# Hyprland downloads
yay -S hyprland-git hyprpaper-git hyprlock-git hypridle-git \\
hyprshot waybar-git wofi hyprpolkitagent-git swaync uwsm

ln -sf "$(pwd)/hypr" "${XDG_CONFIG_HOME:-$HOME/.config}/hypr"
ln -sf "$(pwd)/waybar" "${XDG_CONFIG_HOME:-$HOME/.config}/waybar"
ln -sf "$(pwd)/wofi" "${XDG_CONFIG_HOME:-$HOME/.config}/wofi"
ln -sf "$(pwd)/wlogout" "${XDG_CONFIG_HOME:-$HOME/.config}/wlogout"

# Setup Autologin
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
sudo bash -c 'cat << AUTOCONF > /etc/systemd/system/getty@tty1.service.d/autologin.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o "-p -f -- \\\\u" --noclear --autologin felix %I \$TERM
AUTOCONF'

# Setup Universal Wayland Session Manager
touch ~/.bash_profile
echo 'if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]] && uwsm check may-start; then
    exec uwsm start hyprland.desktop
fi' >> ~/.bash_profile
```

## Terminal Emulator

### kitty

```bash
yay -S kitty
ln -sf "$(pwd)/kitty" "${XDG_CONFIG_HOME:-$HOME/.config}/kitty"
kitten themes 'Gruvbox Dark'
```

### status bar

```bash
yay -S starship
ln -sf "$(pwd)/starship.toml" "${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
```

## Browser

```bash
yay -S firefox
```

## Utilities

### File Browser

```bash
yay -S thunar
```

### PDF Viewer

```bash
yay -S mupdf 
```

### Video viewer

```bash
yay -s mpv
```

### Image viewer

```bash
yay -S imv
```

### Networking

```bash
yay -S networkmanager
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
sudo systemctl status NetworkManager
```

### Audio mixer

```bash
yay -S pavucontrol
```

#### Bluethooth

```bash

yay -S bluez bluez-utils
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
sudo systemctl status bluetooth
# bluetooth GUI
yay -S blueman
```

### Utilities sumary

```bash
#!/usr/bin/env bash

yay -S thunar mupdf mpv imv networkmanager pavucontrol bluez bluez-utils \\
blueman kitty starship

# Install Kitty and Starship
ln -sf "$(pwd)/kitty" "${XDG_CONFIG_HOME:-$HOME/.config}/kitty"
ln -sf "$(pwd)/starship.toml" "${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
# bluetooth service
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
sudo systemctl status bluetooth
# NetworkManager service
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
sudo systemctl status NetworkManager
```

## Code editor

### Install Neovim from Git

```bash
git clone https://github.com/neovim/neovim ~/git-Downloads/neovim
cd ~/git-Downloads
make CMAKE_BUILD_TYPE=Release
sudo make install
```

### Download config from personal repo

```bash
gh repo clone neovim-config ~/git/neovim-config
ln -s ~/git/neovim-config ~/.config/nvim
```

[Neovim config repo](https://github.com/felixg13/neovim-config)

### Neovim summary

```bash
#!/usr/bin/env bash

# Install Neovim
git clone https://github.com/neovim/neovim ~/git-Downloads/neovim
cd ~/git-Downloads
make CMAKE_BUILD_TYPE=Release
sudo make install

# Download and configure Neovim
gh repo clone neovim-config ~/git/neovim-config
ln -s ~/git/neovim-config ~/.config/nvim
```

## others

### Grub

[link](https://www.gnome-look.org/p/2150304)
