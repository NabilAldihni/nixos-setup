{ inputs, config, lib, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Optimise on every build
  nix.settings.auto-optimise-store = true;

  # Remove garbage automatically
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Bootloader.
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;

      configurationLimit = 5;
    };

    efi = {    
      efiSysMountPoint = "/boot";
    };
  };

  networking.hostName = "nixos";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  system.stateVersion = "25.05";

  # Display manager
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # Enable Wayland + Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.seatd.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];



  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  virtualisation.docker = {
    enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nabil = {
    isNormalUser = true;
    description = "Nabil";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICBa6twmSw6a8kvu41c/k56G9ytgC9VJVPDhyizzbTSD nabil@computer"
    ];
    packages = with pkgs; [

    ];
  };

  security.sudo.enable = true;
  security.sudo.extraRules = [
    {
      users = ["nabil"];
      commands = [{ command = "ALL"; options = ["NOPASSWD"]; }];
    }
  ];

  programs.firefox.enable = true;

  programs.git = {
    enable = true;
    config = {
      user = {
        name = "Nabil Aldihni Garcia";
        email = "aldihninabil@gmail.com";
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    bash
    git
    wget
    alacritty
    mesa
    jq
    fd
    ripgrep
    dig
    file
    tree
    unzip
    brightnessctl
    wayland
    hyprpaper hyprlock waybar
    home-manager
  ];

  environment.variables.EDITOR = "vim";
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1"; # Sometimes needed in VMs
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";       # Firefox Wayland
    NIXOS_OZONE_WL = "1";           # Electron/Chromium Wayland
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "no";
  };


  fonts.packages = with pkgs; [
    font-awesome
  ];

  services.tailscale.enable = true;

}
