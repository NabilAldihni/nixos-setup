{ inputs, config, pkgs, ... }:

{
  imports = [
    ./modules/sh.nix
    ./modules/dis.nix
    ./modules/nixcord.nix
    ./modules/hypr/hyprland.nix
    ./modules/hypr/hypridle.nix
    ./modules/hypr/hyprpaper.nix
    ./modules/hypr/waybar.nix
    ./modules/hypr/rofi.nix
    ./modules/tmux.nix
    ./modules/nvim.nix
    inputs.nixcord.homeModules.nixcord
  ];
  home.stateVersion = "25.05"; # Do not change this value
    programs.home-manager.enable = true;

  home.username = "nabil";
  home.homeDirectory = "/home/nabil";

  home.packages = with pkgs; [
    hyprpicker
  ];

  home.sessionVariables = {
    TERMINAL = "alacritty";
  };

  home.sessionPath = [
    "$HOME/dot-files/scripts"
  ];

  home.file = {
    ".gnupg/gpg-agent.conf".text = ''
      default-cache-ttl 28800
      max-cache-ttl 86400
    '';
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
    hyprpolkitagent.enable = true;
  };

  home.file.".config/swaync/style.css".source =
    config.lib.file.mkOutOfStoreSymlink
      "/home/nabil/dot-files/swaync/style.css";
      
  home.file.".config/alacritty/alacritty.toml".source =
    config.lib.file.mkOutOfStoreSymlink
      "/home/nabil/dot-files/alacritty/.config/alacritty/alacritty.toml";

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      pwn-college = {
        HostName = "dojo.pwn.college";
        User = "hacker";
        IdentityFile = "~/.ssh/id_ed25519";
      };

      debian-nginx = {
        HostName = "192.168.30.51";
        User = "root";
        IdentityFile = "~/.ssh/id_lab";
      };

      ubuntu-docker = {
        HostName = "192.168.10.51";
        User = "nabil";
        IdentityFile = "~/.ssh/id_lab";
      };

      debian-vault = {
        HostName = "192.168.40.51";
        User = "nabil";
        IdentityFile = "~/.ssh/id_lab";
      };

      debian-mc = {
        HostName = "192.168.10.52";
        User = "nabil";
        IdentityFile = "~/.ssh/id_lab";
      };

      k8s-ctrlr = {
        HostName = "192.168.40.56";
        User = "nabil";
        IdentityFile = "~/.ssh/id_lab";
      };

      k8s-worker1 = {
        HostName = "192.168.40.57";
        User = "nabil";
        IdentityFile = "~/.ssh/id_lab";
      };

      k8s-worker2 = {
        HostName = "192.168.40.58";
        User = "nabil";
        IdentityFile = "~/.ssh/id_lab";
      };

      t2l-dev1 = {
        HostName = "192.168.50.51";
        User = "nabil";
        IdentityFile = "~/.ssh/id_lab";
      };

      proxmox = {
        HostName = "100.118.68.78";
        User = "root";
        IdentityFile = "~/.ssh/id_lab";
      };

      kali = {
        HostName = "192.168.40.56";
        User = "kali";
        IdentityFile = "~/.ssh/id_lab";
      };

      dns-01 = {
        HostName = "192.168.30.53";
        User = "nabil";
        IdentityFile = "~/.ssh/id_lab";
      };

      exit-node = {
        HostName = "192.168.30.54";
        User = "root";
        IdentityFile = "~/.ssh/id_lab";
      };

      c2 = {
        HostName = "192.168.20.2";
        User = "nabil";
        IdentityFile = "~/.ssh/id_lab";
      };

      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };
    };
  };

}
