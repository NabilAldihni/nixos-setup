{ config, pkgs, ... }:
let
  nvim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
    withPython3 = false;
    withRuby = false;
    vimAlias = true;
    wrapRc = false;
    extraMakeWrapperArgs = [
      "--suffix"
      "PATH"
      ":"
      (pkgs.lib.makeBinPath [ pkgs.gcc ])
    ];
  };
in
{
  home.packages = [ nvim ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink
      "/home/nabil/dot-files/nvim/.config/nvim";
}
