{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      monitor=,preferred,auto,1
      exec-once = waybar &
      exec-once = hyprpaper &
    '';
  };
}
