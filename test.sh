#!/bin/bash
if [[ $(diff -r ./.zsh-vi-mode ~/.shit_from_git/.zsh-vi-mode) != "" ]]; then
#|| [ $("diff -r ./.zsh-vi-mode ~/.shit_from_git/.zsh-vi-mode") == 0 ]; then
    echo "OK"
fi
