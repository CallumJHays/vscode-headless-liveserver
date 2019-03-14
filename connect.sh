#!/bin/bash

unameOut=$(uname -s)
case "${unameOut}" in
    Linux*)     local=Linux;;
    Darwin*)    local=Mac;;
    *)          local=Unsupported;;
esac

# if xpra isn't installed locally, install it
if ! hash xpra 2>/dev/null
then
    if [[ "${local}" == "Mac" ]]
    then
        echo "no xpra installation found! auto-install beginning.."
        brew install Caskroom/cask/xpra
    elif "${local}" == "Linux"
    then
        echo "no xpra installation found! auto-install beginning.."
        cat xpra_repo_gpg.asc | apt-key add -
        echo "deb http://winswitch.org/ buster main" > /etc/apt/sources.list.d/winswitch.list
        sudo $(apt-get update && apt-get install xpra)
    else
        echo "Sorry! This script is unable to find an installation of xpra locally and is not able to automatically install it for you on your provided platform (${unameOut}). Currently supported platforms are 'Darwin Mac' and 'Debian'"
        exit 1
    fi
fi

# connect to X11 desktop via xpra over ssh
xpra attach ssh/vscode/2022 --ssh="ssh vscode"