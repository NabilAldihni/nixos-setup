{ config, pkgs, ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      v = "nvim";
      rb = "sudo nixos-rebuild switch --flake ~/config";
      hrb = "home-manager switch --flake ~/config";

      # To run pintos docker command
      pintos-up = "docker run --platform linux/amd64 --rm --name pintos -it -v /home/nabil/uni/CSCC69-Pintos/:/pintos thierrysans/pintos";
    };
    bashrcExtra = ''
      if [[ $- == *i* ]]; then
        bind 'set completion-ignore-case on'
      fi
  '';
  };
}
