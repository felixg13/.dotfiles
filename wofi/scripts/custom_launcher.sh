#!/bin/bash
echo "Open Neovim Project"
echo "Launch Firefox"
echo "Open Terminal"

case "$(cat)" in
"Open Neovim Project")
  alacritty -e nvim ~/my_project
  ;;
"Launch Firefox")
  firefox
  ;;
"Open Terminal")
  alacritty
  ;;
*) ;;
esac
