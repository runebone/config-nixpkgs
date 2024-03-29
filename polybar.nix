{ config, pkgs, ... }:

with {
  colors = {
    background = "#282A2E";
    background-alt = "#373B41";
    foreground = "#C5C8C6";
    # primary = "#2C78BF";
    # primary = "#4285F4";
    # primary = "#519ABA";
    # secondary = "#68A8E4";
    secondary = "#0AAEB3";
    alert = "#EF2F27";
    disabled = "#707880";

    black = "#000000";
    green = "#98BC37";
    magenta = "#E02C6D";
  };
};

{
  services.polybar = {
    enable = true;

    config = {
      "colors" = colors;

      "bar/main" = {
        bottom = "false";

        width = "100%";
        height = "24pt";
        radius = "0";

        background = "\${colors.background}";
        foreground = "\${colors.foreground}";

        line-size = "3pt";
        border-size = "0pt";
        border-color = "#00000000";

        padding-left = "0";
        padding-right = "1";

        module-margin = "1";

        separator = "|";
        separator-foreground = "\${colors.disabled}";

        font-0 = "monospace;2";

        modules-left = "xworkspaces xwindow";
        modules-center = "date";
        modules-right = "filesystem memory cpu custompulse wlan battery xkeyboard";

        cursor-click = "pointer";
        cursor-scroll = "ns-resize";

        enable-ipc = "true";
      };

      "module/xworkspaces" = {
        type = "internal/xworkspaces";

        label-active = "%name%";
        label-active-background = "\${colors.background-alt}";
        # label-active-underline = "\${colors.primary}";
        label-active-underline = "\${colors.background-alt}";
        label-active-padding = "1";

        label-occupied = "%name%";
        label-occupied-padding = "1";

        label-urgent = "%name%";
        label-urgent-background = "\${colors.alert}";
        label-urgent-padding = "1";

        label-empty = "%name%";
        label-empty-foreground = "\${colors.disabled}";
        label-empty-padding = "1";
      };

      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title:0:60:...%";
      };

      "module/date" = {
        type = "internal/date";
        interval = "1";

        date = "%d %A %H:%M";
        date-alt = "%d %B %Y %H:%M:%S";

        label = "%date%";
        label-foreground = "\${colors.foreground}";
      };

      "network-base" = {
        type = "internal/network";
        interval = "5";
        format-connected = "<label-connected>";
        format-disconnected = "<label-disconnected>";
        label-disconnected = "{F${colors.disabled}}%ifname%%{F${colors.disabled}} disconnected";
      };

      "module/wlan" = {
        "inherit" = "network-base";
        interface-type = "wireless";
        label-connected = "%{F${colors.disabled}}%ifname%%{F-} %essid%";
      };

      "module/filesystem" = {
        type = "internal/fs";
        interval = "25";

        mount-0 = "/";

        label-mounted = "%{F${colors.disabled}}%mountpoint%%{F-} %percentage_used%%";

        label-unmounted = "%mountpoint% not mounted";
        label-unmounted-foreground = "${colors.disabled}";
      };

      "module/memory" = {
        type = "internal/memory";
        interval = "2";
        format-prefix = "RAM ";
        format-prefix-foreground = "\${colors.disabled}";
        label = "%percentage_used:2%%";
      };

      "module/cpu" = {
        type = "internal/cpu";
        interval = "2";
        format-prefix = "CPU ";
        format-prefix-foreground = "\${colors.disabled}";
        label = "%percentage:2%%";
      };

      "module/custompulse" = {
        # TODO: make exec dir relative;
        # create colors (disabled for muted), 
        type = "custom/script";
        interval = "2";
        # tail = "true"; # eats so much
        exec = "~/.config/home-manager/scripts/custompulse.sh";

        format-prefix = "VOL ";
        format-prefix-foreground = "\${colors.disabled}";

        click-left = "${pkgs.pamixer}/bin/pamixer -t";
      };

      "module/battery" = {
        type = "internal/battery";

        battery = "BAT0";
        adapter = "ACAD";

        format-discharging = "Discharging <label-discharging>";

        label-discharging = "%percentage:3%%";

        format-charging = "Charging <label-charging>";

        label-charging = "%percentage:3%%";

        format-full = "Full";
        format-full-foreground = "\${colors.foreground}";

        label-full = "%percentage:3%%";
      };

      "module/xkeyboard" = {
        type = "internal/xkeyboard";
        blacklist-0 = "num lock";
        blacklist-1 = "caps lock";

        label-layout = "%layout%: %variant%";
        label-layout-foreground = "\${colors.background}";
        label-layout-background = "\${colors.foreground}";
        label-layout-padding = "2";
        label-layout-margin = "1";

        label-indicator-padding = "2";
        label-indicator-margin = "1";
        label-indicator-foreground = "\${colors.background}";
        label-indicator-background = "\${colors.secondary}";
      };

      "settings" = {
        screenchange-reload = "true";
        pseudo-transparency = "true";
      };
    };

    script = "exec polybar main &";
  };
}
