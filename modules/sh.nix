{ config, pkgs, ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      v = "nvim";
      rb = "sudo nixos-rebuild switch --flake ~/config --impure";
      hrb = "home-manager switch --flake ~/config";

      # To run pintos docker command
      pintos-up = "docker run --platform linux/amd64 --rm --name pintos -w /pintos/src -it -v /home/nabil/uni/C69/:/pintos thierrysans/pintos";

      # To use dotcoin
      dotcoin = "npm run cli --";
    };
    bashrcExtra = ''
      if [[ $- == *i* ]]; then
        bind 'set completion-ignore-case on'
      fi
  '';
  };
}
