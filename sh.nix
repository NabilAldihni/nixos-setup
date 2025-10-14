{ config, pkgs, ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
    };
  };
}
