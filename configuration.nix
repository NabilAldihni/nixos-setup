{ inputs, config, lib, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";


  # Display manager
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # Enable Wayland + Hyprland
  programs.hyprland.enable = true;

  services.seatd.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];



  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.displayManager.gdm.enable = true;
  # services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb = {
    # layout = "us";
    # variant = "";
  # };



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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nabil = {
    isNormalUser = true;
    description = "Nabil";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCiAp36nKSnIwCmy/kiDe4qDEVBLRNy7eKXm6luc2NVbsqsuzk1Z5evfiIEXVN7qtPiyLVFqBtFcAC64u7Du0Ps2gVFBF/U8gP+JXISbcJlVvGUCC0eEuWo4ovElDX7ibEzdSYrT7jQRh4MsZOK6Bo6qwB+l/ry4juwTxF7nbkMn2irUhjpZ6JOTIaAQbsHopz3AsCnddJXpPEq9GxPRUIFXqrhxvXsv47mQdV187KqXCG6oH/2iFAFNFhiiws+bLJNnc66qgSngqLbO9lHD5r6SqJ78YpaEG2d6XlUXVXEJxqYTbGmWbvqN5q7LsOfQRiob+AUTPjLNA83dLg+jZacnXuJxbBKJa/DbjRhVYx0/lwV1iM7fj+CdT3xSaBvIB4JVlQonnsA2r/8g0+ttxHH3ZACEQEPIzQflebOGPHSj75dRLVWyioUnKzTk9HGiyndcAjf12cZm/2PhQpGPclw1ijq2OFm05J6E682mAfzhK2qhYKXYG6/oWK50P/k+0c= github"
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

  # Install firefox.
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    mesa
    wayland
    hyprpaper hyprlock waybar # good wayland tools
  #  home-manager
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

  system.stateVersion = "25.05";

}
