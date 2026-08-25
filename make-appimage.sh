#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook:wayland-is-broken.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/ymir-emu/Ymir/refs/heads/main/apps/ymir-sdl3/res/ymir.png
export DESKTOP=https://raw.githubusercontent.com/ymir-emu/Ymir/refs/heads/main/apps/ymir-sdl3/res/io.github.strikerx3.ymir.desktop
export STARTUPWMCLASS=ymir-sdl3
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1

# Deploy dependencies
quick-sharun ./AppDir/bin/ymir-sdl3

# Turn AppDir into AppImage
quick-sharun --make-appimage
