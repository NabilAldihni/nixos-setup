{ config, pkgs, ... }:
{
  home.packages = [ pkgs.tmux ];

  home.file.".config/tmux".source =
    config.lib.file.mkOutOfStoreSymlink
      "/home/nabil/dot-files/tmux";
}
