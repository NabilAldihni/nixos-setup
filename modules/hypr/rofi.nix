{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    rofi
  ];

  home.file.".config/rofi".source =
    config.lib.file.mkOutOfStoreSymlink
      "/home/nabil/dot-files/rofi/.config/rofi";
}
