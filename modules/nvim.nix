{ config, pkgs, ... }:
{
  programs.neovim.enable = true;

  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink
      "/home/nabil/dot-files/nvim/.config/nvim";
}
