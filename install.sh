#!/usr/bin/env bash

#nix-shell -p git --command "nix run --experimental-features 'nix-command flakes' gitlab:librephoenix/nixos-config"

yay -S hyprland-git gdb ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite xorg-xinput libxrender pixman wayland-protocols cairo pango seatd libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus hyprlang hyprcursor hyprwayland-scanner xcb-util-errors hyprutils-git

