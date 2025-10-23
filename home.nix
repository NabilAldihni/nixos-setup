{ config, pkgs, ... }:

{
  imports = [
    ./modules/sh.nix
    ./modules/dis.nix
    ./modules/hypr/hyprland.nix
    ./modules/hypr/hyprpaper.nix
    ./modules/hypr/waybar.nix
  ];
  home.stateVersion = "25.05"; # Do not change this value
  programs.home-manager.enable = true;

  home.username = "nabil";
  home.homeDirectory = "/home/nabil";

  home.packages = [
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.file = {
  };

  programs.direnv = {
    enable = true;
    silent = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.tmux.enable = true;
}
