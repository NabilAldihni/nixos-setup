{ config, pkgs, ... }:

{
  imports = [
    ./modules/sh.nix
      ./modules/dis.nix
      ./modules/hypr/hyprland.nix
      ./modules/hypr/hypridle.nix
      ./modules/hypr/hyprpaper.nix
      ./modules/hypr/waybar.nix
      ./modules/hypr/rofi.nix
      ./modules/tmux.nix
      ./modules/nvim.nix
  ];
  home.stateVersion = "25.05"; # Do not change this value
    programs.home-manager.enable = true;

  home.username = "nabil";
  home.homeDirectory = "/home/nabil";

  home.packages = with pkgs; [
    vesktop
      hyprpicker
  ];

  home.sessionVariables = {
    TERMINAL = "alacritty";
  };

  home.sessionPath = [
    "$HOME/dot-files/scripts"
  ];

  home.file = {
  };

  programs.direnv = {
    enable = true;
    silent = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  services = {
    swaync.enable = true;
    mpris-proxy.enable = true;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      pwn-college = {
        host = "pwn-college";
        hostname = "dojo.pwn.college";
        user = "hacker";
        identityFile = "~/.ssh/id_ed25519";
      };

      debian-nginx = {
        host = "debian-nginx";
        hostname = "192.168.30.51";
        user = "root";
        identityFile = "~/.ssh/id_lab";
      };

      ubuntu-docker = {
        host = "ubuntu-docker";
        hostname = "192.168.10.51";
        user = "nabil";
        identityFile = "~/.ssh/id_lab";
      };

      debian-vault = {
        host = "debian-vault";
        hostname = "192.168.40.51";
        user = "nabil";
        identityFile = "~/.ssh/id_lab";
      };

      debian-mc = {
        host = "debian-mc";
        hostname = "192.168.10.52";
        user = "nabil";
        identityFile = "~/.ssh/id_lab";
      };

      k8s-ctrlr = {
        host = "k8s-ctrlr";
        hostname = "192.168.40.56";
        user = "nabil";
        identityFile = "~/.ssh/id_lab";
      };

      k8s-worker1 = {
        host = "k8s-worker1";
        hostname = "192.168.40.57";
        user = "nabil";
        identityFile = "~/.ssh/id_lab";
      };

      k8s-worker2 = {
        host = "k8s-worker2";
        hostname = "192.168.40.58";
        user = "nabil";
        identityFile = "~/.ssh/id_lab";
      };

      t2l-dev1 = {
        host = "t2l-dev1";
        hostname = "192.168.50.51";
        user = "nabil";
        identityFile = "~/.ssh/id_lab";
      };

      proxmox = {
        host = "proxmox";
        hostname = "100.118.68.78";
        user = "root";
        identityFile = "~/.ssh/id_lab";
      };

      kali = {
        host = "kali";
        hostname = "192.168.40.56";
        user = "kali";
        identityFile = "~/.ssh/id_lab";
      };

      d21 = {
        host = "d21";
        hostname = "limit-order-exchange-exchange101.amazingcloud.space";
        user = "root";
        identityFile = "~/.ssh/id_ed25519";
      };

      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
    };
  };

}
