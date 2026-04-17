# nixos-setup

My personal NixOS configuration files. 

Currently a configuration for the Dell XPS 13 9315 and Proxmox VMs.

## New install

### Preparing the USB

1. Put `setup.sh` in a USB. 
2. Create a Github Personal Access Token with Content->Read-Only rights to this repo and [dot-files](https://github.com/NabilAldihni/dot-files).
3. Add that PAT to a new file called `github-pat.txt`, and put it in the USB.
4. If you have a preferred wallpaper, add it in the USB under a `wallpapers` directory. For now it must be called `test.png`.

### Fresh install

Install NixOS, you can use the graphical installer. Most values don't matter too much, just create a user called `nabil`. 
Feel free to create it with no DE, it won't make a difference.

Once installed and booted, plug in the USB and mount it:
```bash
mkdir -p /mnt/usb && sudo mount /dev/sdX1 /mnt/usb
```

Finally, to get it all running do
```bash
./setup.sh
```

It will ask whether you're setting up the laptop or a VM. Then it will clone the nixos-setup and dot-files repos, 
copy the hardware configuration, and run `nixos-rebuild boot`. It will automatically reboot when done.

### Post-Install

After reboot, the whole Desktop Environment will be configured, but some more tasks will be required:
 - If you didn't set a good password when installing Nixos, run `passwd nabil` now to reset it.
 - Sign into 1Password
 - Sign into Zen browser (settings -> sync -> sign in)
 - Restore SSH keys from 1Password to `~/.ssh/` and `chmod 600` the private keys.
 - Download and restore GPG key from 1Password with `gpg --import` (paste the key, then Ctrl+D)
 - Rotate the Github PAT and update it in the USB's `github-pat.txt`
 - Sign into Tailscale (`sudo tailscale up && sudo tailscale set --operator=nabil`)
 - Sign into Discord

## Rebuilding on a running system

Aliases set up for ease of use:
```bash
rb    # full system rebuild, defaults to #nixos which is currently laptop profile
hrb   # home-manager only
```
