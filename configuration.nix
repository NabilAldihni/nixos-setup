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
    options = "--delete-older-than 14d";
  };

# Bootloader.
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
      extraConfig = "";

      configurationLimit = 5;
    };

    efi = {    
      efiSysMountPoint = "/boot";
    };
  };

  networking.hostName = "nixos";

# Enable networking
  networking.networkmanager.enable = true;

  networking.nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];

  services.resolved.settings.Resolve = {
    enable = true;
    DNSSec = "false";
    Domains = [ "~." ];
    FallbackDNS = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    DNSOverTLS = "false";
  };


  hardware.bluetooth = {
    enable = true;
    settings.General = {
      Experimental = true;
    };
  };

  hardware.enableRedistributableFirmware = true;

  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep"; # Alder Lake — XPS 9315
  };

  hardware.firmware = [ pkgs.ivsc-firmware ];

  services.udev.extraRules = ''
    # Hide IPU6 internal pipeline nodes — real cameras are the v4l2loopback devices
    SUBSYSTEM=="video4linux", SUBSYSTEMS=="pci", KERNELS=="0000:00:05.0", GROUP="root", MODE="0600", TAG-="uaccess"
    # Hide dummy v4l2loopback device
    SUBSYSTEM=="video4linux", ATTRS{name}=="Dummy video device (0x0000)", GROUP="root", MODE="0600", TAG-="uaccess"
  '';

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
  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

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
    extraGroups = [ "networkmanager" "wheel" "docker" "video" ];
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

  security.pki.certificates = [ "-----BEGIN CERTIFICATE-----
MIIDJTCCAg2gAwIBAgIUDDNTGos7LtEPyCz+LAA6J7Qk+eEwDQYJKoZIhvcNAQEL
BQAwGjEYMBYGA1UEAxMPYmlsLmxhYiBSb290IENBMB4XDTI1MDExNTAzMjgyMVoX
DTM1MDExMzAzMjg1MVowGjEYMBYGA1UEAxMPYmlsLmxhYiBSb290IENBMIIBIjAN
BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1weirqwO3bophgXoUhT9rUPFOaR+
YYdFUwGnCxpCYUx3SzxGP268bA2OQnKyk7b6Y2P6CscZD/gd8lmXcpWSPRZWNaZN
Qv9/WETG3AOOUKI4Dhk5EoshG43bUXXM4iNIPnPsVWT/u5G3T0IzaW18aP8qUcPu
1WpXYF78KnCBDBXexgjA+m/eYcV4oKzL0eRSnKm6sVIpzGYXYe5kdtNCAh6W8mJI
z3rqpiGZMy2XMWqU0NSfTFsAhXnKUTjQAH7nz0QpkOMRoj8HbXNw6tLFLQSh/cdc
CVTFWbQNuAmvnwizMm0fqCQyIzXpUdhodAiHJp9UOZ6gQC96fKKajMBl/wIDAQAB
o2MwYTAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQU
LTYp1ryMjAwT+yIv003izh58hv0wHwYDVR0jBBgwFoAULTYp1ryMjAwT+yIv003i
zh58hv0wDQYJKoZIhvcNAQELBQADggEBADwIIvcp1dDisGaAjRQeCyNRDA8YvrAK
12NgDTyB3kmll3YyBiQ5+FUMNnU65YiNIHxgvVN1KD+L6PFafoRVfV9Rp2UZ2LYm
0sYJTyTafsWcF3H5p0WoWo/e8X5WMY/KP3mq4CAe0gLcBkl1JXtOva7iF9Dc/iC5
ym/XNRTZDZNJS0JmLwjV/CwDyfkQ/XxVjf125Rxmdo3EmcVVekP60BRmsngzHKYH
AJC0t0sN7ZoS4eeFgwj37ukrfcVP+zkMZnRtyJUw2K+JJrtJIqequ90Yz5dcqOQ3
XC1gOVNVlwbBusLvURRFKs5S12ZvGjkGsfH4/izrl6+9ft87cUczbhY=
-----END CERTIFICATE-----" ];

  programs.firefox.enable = true;

  programs.git = {
    enable = true;
    config = {
      user = {
        name = "Nabil Aldihni Garcia";
        email = "aldihninabil@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  nixpkgs.config.allowUnfree = true;

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
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  services.tlp.enable = true;

  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";
  services.blueman.enable = true;
  services.fprintd.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
# Certain features, including CLI integration and system authentication support,
# require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "nabil" ];
  };

  programs.steam = {
    enable = true;
  };

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };

  # Fixing the mic LED to follow the actual muting
  systemd.services.configure-sound-leds = {
  # wantedBy = [ "sys-devices-pci0000:00-0000:00:1f.3-sof_sdw-sound-card0-controlC0.device" ];
    wantedBy = [ "sound.target" ];
    after = [ "sound.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      echo follow-route > /sys/class/sound/ctl-led/mic/mode
      echo off > /sys/class/sound/ctl-led/speaker/mode # follow-route pending https://discourse.nixos.org/t/20480
      '';
  };

  # Fix laptop microphone on XPS 9315 (rt714 codec via sof-soundwire).
  # PGA5.0 capture switch starts off by default and is not set by any UCM config
  # (upstream gap in alsa-ucm-conf for the rt715-sdca/rt714 codec).
  systemd.services.configure-microphone = {
    wantedBy = [ "sound.target" ];
    after = [ "sound.target" ];
    serviceConfig.Type = "oneshot";
    path = [ pkgs.alsa-utils ];
    script = ''
      amixer -c 0 cset name='PGA5.0 5 Master Capture Switch' on
      amixer -c 0 cset name='rt714 ADC 22 Mux' 'DMIC3'
      amixer -c 0 cset name='rt714 ADC 23 Mux' 'DMIC4'
    '';
  };

  environment.systemPackages = with pkgs; [
    alsa-ucm-conf

    # Toggles PipeWire mute AND the hardware PGA5.0 capture switch together,
    # so the mic mute LED (which watches PGA5.0) stays in sync with actual mute state.
    (writeShellScriptBin "toggle-mic" ''
      ${wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      if ${wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q '\[MUTED\]'; then
        ${alsa-utils}/bin/amixer -c 0 cset name='PGA5.0 5 Master Capture Switch' off
      else
        ${alsa-utils}/bin/amixer -c 0 cset name='PGA5.0 5 Master Capture Switch' on
      fi
    '')

    vim
    bash
    git
    wget
    gcc clang-tools
    alacritty
    kdePackages.dolphin
    mesa
    jq
    openvpn
    fd
    feh
    ripgrep
    dig
    pywal
    traceroute
    gnupg
    pinentry-gtk2
    whois
    file
    tree
    grim slurp wl-clipboard
    unzip
    python3
    yarn
    usbutils
    nodejs
    brightnessctl
    remmina
    slack 
    wayland hyprpaper hyprlock hyprpolkitagent waybar
    home-manager
    claude-code code-cursor
    inputs.zen-browser.packages.${stdenv.hostPlatform.system}.default
  ];

}
