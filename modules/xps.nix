# Hardware-specific configuration for Dell XPS 13 9315
{ inputs, config, lib, pkgs, ... }:

{
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = false;
      configurationLimit = 5;
      timeout = 1;
    };
    efi.efiSysMountPoint = "/boot";
  };

  hardware.enableRedistributableFirmware = true;

  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep"; # Alder Lake — XPS 9315
  };

  # The Intel camera HAL writes runtime adaptation data (.aiqd files) to /run/camera
  systemd.tmpfiles.rules = [ "d /run/camera 0755 root root -" ];

  hardware.firmware = [ pkgs.ivsc-firmware ];

  services.udev.extraRules = ''
    # Hide IPU6 internal pipeline nodes — real cameras are the v4l2loopback devices
    SUBSYSTEM=="video4linux", SUBSYSTEMS=="pci", KERNELS=="0000:00:05.0", GROUP="root", MODE="0600", TAG-="uaccess"
    # Hide dummy v4l2loopback device
    SUBSYSTEM=="video4linux", ATTRS{name}=="Dummy video device (0x0000)", GROUP="root", MODE="0600", TAG-="uaccess"
  '';


  hardware.bluetooth = {
    enable = true;
    settings.General = {
      Experimental = true;
    };
  };
  services.blueman.enable = true;

  services.fprintd.enable = true;
  services.tlp.enable = true;

  # Fixing the mic LED to follow the actual muting
  systemd.services.configure-sound-leds = {
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
  ];
}
