#!/usr/bin/env bash
set -e

GITHUB_USER="NabilAldihni"
CONFIG_REPO="nixos-setup"
DOTFILES_REPO="dot-files"

if [ ! -f ./github-pat.txt ]; then
  echo "github-pat.txt not found"
  exit 1
fi

echo "Which config do you want to apply?"
echo "  1) XPS laptop (nixos)"
echo "  2) VM (vm)"
read -rp "Choice [1/2]: " choice
case "$choice" in
  1) FLAKE_TARGET="nixos" ;;
  2) FLAKE_TARGET="vm" ;;
  *) echo "Invalid choice"; exit 1 ;;
esac

PAT=$(cat ./github-pat.txt)
BASE_URL="https://${PAT}@github.com/${GITHUB_USER}"

echo "Cloning repos..."
[ -d "$HOME/config" ]    || nix-shell -p git --run "git clone ${BASE_URL}/${CONFIG_REPO}.git $HOME/config"
[ -d "$HOME/dot-files" ] || nix-shell -p git --run "git clone ${BASE_URL}/${DOTFILES_REPO}.git $HOME/dot-files"

echo "Copying hardware configuration from this machine..."
cp /etc/nixos/hardware-configuration.nix "$HOME/config/hardware-configuration.nix"

if [ -d ./wallpapers ]; then
  echo "Copying wallpapers..."
  cp -r ./wallpapers "$HOME/wallpapers"
  nix-shell -p pywal --run "wal -i $HOME/wallpapers/test.png -n"
fi

echo "Applying NixOS config..."
sudo nixos-rebuild boot --flake "$HOME/config#${FLAKE_TARGET}"

echo -e "\n\n------------ Done. ------------"
echo "Refer to the nixos-setup README for post-install steps."
echo "Rebooting in 5 seconds..."
sleep 5
sudo reboot
