{ config, pkgs, ... }:
{
  programs.tmux.enable = true;

  home.file.".tmux.conf".source =
    config.lib.file.mkOutOfStoreSymlink
      "/home/nabil/dot-files/tmux/.tmux.conf";
}
