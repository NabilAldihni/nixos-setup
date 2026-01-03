{ config, pkgs, ... }:

let
  tailscaleScript = pkgs.writeShellScriptBin "tailscale-status" ''
    status=$(tailscale status --json 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo '{"text": "", "tooltip": "Tailscale not running", "class": "disconnected"}'
        exit 0
    fi

    state=$(echo "$status" | jq -r '.BackendState')
    if [ "$state" = "Running" ]; then
        echo "{\"text\": \"\", \"tooltip\": \"Tailscale connected ($ip)\", \"class\": \"connected\"}"
    else
        echo "{\"text\": \"\", \"tooltip\": \"Tailscale backend not running ($state)\", \"class\": \"disconnected\"}"
    fi
  '';
in
{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "workspaces" "window" ];
        modules-center = [ "clock" ];
        modules-right = [ "battery" "custom/tailscale" "pulseaudio" ];

        clock = {
          format = "{:%Y-%m-%d %H:%M}";
        };

        "custom/tailscale" = {
          exec = "${tailscaleScript}/bin/tailscale-status";
          interval = 5;
          return-type = "json";
        };
      };
    };

    style = ''
      window#waybar {
        background-color: rgba(30, 30, 30, 0.7);
        color: white;
      }

      #custom-tailscale.connected {
        color: #4caf50; /* green */
      }

      #custom-tailscale.disconnected {
        color: #f44336; /* red */
      }
    '';

  };
}
