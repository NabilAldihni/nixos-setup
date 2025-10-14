{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "workspaces" "window" ];
        modules-center = [ "clock" ];
        modules-right = [ "tray" "battery" "network" "cpu" ];

        clock = {
          format = "{:%Y-%m-%d %H:%M}";
        };
      };
    };

  };
}
