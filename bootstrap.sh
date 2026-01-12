#!/bin/bash

BASE_URL="https://github.com/chucko42/bash-dotfiles/main"

echo "Installing unified .bashrc..."
curl -s "$BASE_URL/bashrc" -o ~/.bashrc

echo "Installing home override..."
curl -s "$BASE_URL/bashrc.home" -o ~/.bashrc.home

echo "Done. Reload your shell."

