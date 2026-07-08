# Hardware-specific configuration for Dell XPS 13 9315
{ inputs, config, lib, pkgs, ... }:

{
  boot.loader = {
    timeout = 1;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = false;
      configurationLimit = 5;
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
    # Goodix fingerprint: keep USB powered — autosuspend races with hyprlock on resume
    SUBSYSTEM=="usb", ATTR{idVendor}=="27c6", ATTR{idProduct}=="63ac", ATTR{power/control}="on"
  '';

  # Stop fprintd before suspend so hyprlock gets a clean daemon via socket activation on wake.
  systemd.packages = [
    (pkgs.writeTextFile {
      name = "fprintd-system-sleep";
      destination = "/lib/systemd/system-sleep/fprintd";
      executable = true;
      text = ''
        #!${pkgs.bash}/bin/bash
        case "$1" in
          pre)
            systemctl stop fprintd.service 2>/dev/null || true
            ;;
        esac
      '';
    })
  ];


  hardware.bluetooth = {
    enable = true;
    settings.General = {
      Experimental = true;
    };
  };
  services.blueman.enable = true;

  services.fprintd.enable = true;
  services.tlp.enable = true;

  # XPS 9315 audio: mic LED follows PGA mute; DMIC routing; boot muted (PGA off).
  systemd.services.configure-xps-audio = {
    wantedBy = [ "sound.target" ];
    after = [ "sound.target" ];
    serviceConfig.Type = "oneshot";
    path = [ pkgs.alsa-utils ];
    script = ''
      echo follow-route > /sys/class/sound/ctl-led/mic/mode
      echo off > /sys/class/sound/ctl-led/speaker/mode
      amixer -c 0 cset name='rt714 ADC 22 Mux' 'DMIC3'
      amixer -c 0 cset name='rt714 ADC 23 Mux' 'DMIC4'
      amixer -c 0 cset name='PGA5.0 5 Master Capture Switch' off
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
