{ config, pkgs, ... }:

{
  imports = [
    ./modules/sh.nix
    ./modules/dis.nix
    ./modules/hyprland.nix
    ./modules/waybar.nix
  ];
  home.username = "nabil";
  home.homeDirectory = "/home/nabil";

  home.stateVersion = "25.05"; # Do not change this value

  home.packages = [
  ];

  home.file = {
    # ".screenrc".source = dotfiles/screenrc;

    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.home-manager.enable = true;
}
