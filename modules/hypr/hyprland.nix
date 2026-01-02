{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
  };

  home.file.".config/hypr".source = 
    config.lib.file.mkOutOfStoreSymlink
      "/home/nabil/dot-files/hypr";
}
