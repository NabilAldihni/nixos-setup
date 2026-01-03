{ config, pkgs, ... }:

{
  programs.waybar.enable = true;

  home.file.".config/waybar".source = 
    config.lib.file.mkOutOfStoreSymlink
      "/home/nabil/dot-files/waybar";
}
