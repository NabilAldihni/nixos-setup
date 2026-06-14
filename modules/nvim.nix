{ config, pkgs, ... }:
let
  lspPackages = with pkgs; [
    gcc
    tree-sitter
    clang-tools
    typescript-language-server
    typescript
    lua-language-server
    haskell-language-server
    pyright
    bash-language-server
    vscode-langservers-extracted
  ];

  nvim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
    withPython3 = false;
    withRuby = false;
    vimAlias = true;
    wrapRc = false;
    extraMakeWrapperArgs = [
      "--suffix"
      "PATH"
      ":"
      (pkgs.lib.makeBinPath lspPackages)
    ];
  };
in
{
  home.packages = [ nvim ] ++ lspPackages;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink
      "/home/nabil/dot-files/nvim/.config/nvim";
}
