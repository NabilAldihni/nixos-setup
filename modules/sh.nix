{ config, pkgs, ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      rb = "sudo nixos-rebuild switch --flake ~/config";
      hrb = "home-manager switch --flake ~/config";
    };
    bashrcExtra = "bind 'set completion-ignore-case on'";
  };
}
