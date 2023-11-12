#!/bin/bash
if [[ $(diff -r ./.zsh-vi-mode ~/.shit_from_git/.zsh-vi-mode) != "" ]] || [[ $(diff -r ./.zsh-vi-mode ~/.shit_from_git/.zsh-vi-mode) -eq 0 ]]; then
    echo "OK"
fi
