{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.waybar-touch;
  inherit (lib) mkIf mkOption mkEnableOption types;

  workspaceModule =
    if cfg.compositor == "hyprland" then "hyprland/workspaces"
    else if cfg.compositor == "sway" then "sway/workspaces"
    else "wlr/workspaces";

  windowModule =
    if cfg.compositor == "hyprland" then "hyprland/window"
    else if cfg.compositor == "sway" then "sway/window"
    else null;

  modulesLeft = [ workspaceModule ];
  modulesCenter = lib.optional (windowModule != null && cfg.showWindowTitle) windowModule;
  modulesRight = [
    "group/status"
    "clock"
  ];

  workspaceSettings =
    {
      disable-scroll = true;
      all-outputs = true;
      format = "{name}";
      on-click = "activate";
    }
    // lib.optionalAttrs (cfg.compositor == "hyprland") {
      # Always show a few workspace buttons so tap targets stay predictable.
      persistent-workspaces = {
        "1" = [ ];
        "2" = [ ];
        "3" = [ ];
        "4" = [ ];
      };
    };

  statusModules =
    [ "pulseaudio" "network" ]
    ++ lib.optional cfg.battery "battery"
    ++ [ "tray" ];

  mainBar =
    {
      layer = "top";
      position = cfg.position;
      height = cfg.height;
      spacing = cfg.spacing;
      # Keep pointer/touch events on the bar (do not pass through).
      passthrough = false;
      exclusive = true;
      gtk-layer-shell = true;

      modules-left = modulesLeft;
      modules-center = modulesCenter;
      modules-right = modulesRight;

      "group/status" = {
        orientation = "inherit";
        drawer = {
          transition-duration = 300;
          children-class = "status-drawer";
          transition-left-to-right = false;
          # Critical for touch: reveal on tap, not hover.
          click-to-reveal = true;
        };
        modules = statusModules;
      };

      clock = {
        interval = 60;
        format = "{:%a %H:%M}";
        tooltip-format = "{:%Y-%m-%d}";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "muted";
        format-icons.default = [ "vol" ];
        on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        tooltip = true;
      };

      network = {
        format-wifi = "{essid}";
        format-ethernet = "lan";
        format-disconnected = "offline";
        tooltip-format = "{ifname}: {ipaddr}";
      };

      tray = {
        icon-size = 22;
        spacing = 12;
      };
    }
    // {
      "${workspaceModule}" = workspaceSettings;
    }
    // lib.optionalAttrs cfg.battery {
      battery = {
        interval = 30;
        states = {
          warning = 25;
          critical = 10;
        };
        format = "{capacity}%";
        format-charging = "{capacity}%+";
        format-plugged = "{capacity}%=";
        tooltip-format = "{timeTo}";
      };
    }
    // lib.optionalAttrs (windowModule != null && cfg.showWindowTitle) {
      "${windowModule}" = {
        format = "{title}";
        max-length = 40;
        rewrite = {
          "(.*) — Mozilla Firefox" = "$1";
          "(.*) - Chromium" = "$1";
        };
      };
    };
in
{
  options.programs.waybar-touch = {
    enable = mkEnableOption "minimal touch-friendly Waybar";

    compositor = mkOption {
      type = types.enum [ "hyprland" "sway" "other" ];
      default = "hyprland";
      description = "Compositor used for workspace/window modules.";
    };

    position = mkOption {
      type = types.enum [ "top" "bottom" ];
      default = "top";
      description = ''
        Bar edge. Prefer `bottom` on tablets / convertible laptops so
        thumbs can reach modules without stretching.
      '';
    };

    height = mkOption {
      type = types.ints.unsigned;
      default = 48;
      description = "Bar height in px. ~44–48 keeps modules comfortably tappable.";
    };

    spacing = mkOption {
      type = types.ints.unsigned;
      default = 10;
      description = "Gap between modules so adjacent taps are less ambiguous.";
    };

    showWindowTitle = mkOption {
      type = types.bool;
      default = false;
      description = "Show the focused window title (off by default to stay minimal).";
    };

    battery = mkOption {
      type = types.bool;
      default = true;
      description = "Include the battery module (useful for laptops/tablets).";
    };
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings.mainBar = mainBar;
      style = builtins.readFile ./waybar.css;
    };
  };
}
