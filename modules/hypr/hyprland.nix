{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    systemd.enable = false;
  };

  home.file.".config/hypr".source = 
    config.lib.file.mkOutOfStoreSymlink
      "/home/nabil/dot-files/hypr";
}
