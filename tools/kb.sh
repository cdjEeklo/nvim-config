#!/usr/bin/bash
# Modify the key repeat delay and rate
# Wayland with gnome-shell
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:swapescape']"
# you may also use
# setxkbmap -option caps:swapescape
# or
# localectl --no-convert set-x11-keymap be "" "" caps:swapescape
