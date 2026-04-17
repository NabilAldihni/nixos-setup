#!/usr/bin/env bash
set -e

GITHUB_USER="NabilAldihni"
CONFIG_REPO="nixos-setup"
DOTFILES_REPO="dot-files"

if [ ! -f ./github-pat.txt ]; then
  echo "github-pat.txt not found"
  exit 1
fi

PAT=$(cat ./github-pat.txt)
BASE_URL="https://${PAT}@github.com/${GITHUB_USER}"

echo "Cloning repos..."
[ -d "$HOME/config" ]    || nix-shell -p git --run "git clone ${BASE_URL}/${CONFIG_REPO}.git $HOME/config"
[ -d "$HOME/dot-files" ] || nix-shell -p git --run "git clone ${BASE_URL}/${DOTFILES_REPO}.git $HOME/dot-files"

echo "Copying hardware configuration from this machine..."
cp /etc/nixos/hardware-configuration.nix "$HOME/config/hardware-configuration.nix"

echo "Applying NixOS config..."
sudo nixos-rebuild boot --flake ~/config#vm

echo "Done. Reboot to activate the new config."
echo "Remaining manual steps after reboot:"
echo "  1. Copy SSH keys from 1Password to ~/.ssh/ and chmod 600"
echo "  2. passwd nabil"
echo "  3. sudo tailscale up"
echo "  4. Sign into 1Password"
echo "  5. Rotate the GitHub PAT"
