{ config, pkgs, ... }:

{
  imports = [
    ./modules/sh.nix
    ./modules/dis.nix
    ./modules/hypr/hyprland.nix
    ./modules/hypr/hyprpaper.nix
    ./modules/hypr/waybar.nix
    ./modules/hypr/rofi.nix
    ./modules/tmux.nix
  ];
  home.stateVersion = "25.05"; # Do not change this value
  programs.home-manager.enable = true;

  home.username = "nabil";
  home.homeDirectory = "/home/nabil";

  home.packages = with pkgs; [
    vesktop
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    TERMINAL = "alacritty";
  };

  home.file = {
  };

  programs.direnv = {
    enable = true;
    silent = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };
}
