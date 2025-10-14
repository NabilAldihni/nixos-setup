{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = ''
      monitor=,preferred,auto,1

      exec-once = waybar &
      exec-once = hyprpaper &

      $mod = SUPER
      bind = $mod, RETURN, exec, alacritty
      bind = $mod, Q, killactive,
      bind = $mod SHIFT, E, exit,
    '';
  };
}
