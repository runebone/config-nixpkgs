{ config, pkgs, ... }:

with {
  # NOTE: spaces are important
  # TODO: get rid of them later
  EDITOR = " vim ";
  BROWSER = " firefox ";
  TERM = " alacritty ";
};
{
  home = {
    username = "human";
    homeDirectory = "/home/human";
    stateVersion = "22.11";
  };

  home.packages = with pkgs; [
    alacritty
    brightnessctl
    cmake
    copyq # Copy screenshots made by "maim" to clipboard
    firefox
    gcc
    git
    gnumake
    htop
    killall
    lf # CLI file manager
    maim # "make image"; for screenshots
    mpv # Open video-files
    neofetch # Of course
    obs-studio
    pamixer # PulseAudio mixer
    picom # Ricing
    polybar
    qtcreator # Qt's vim is actually faster than VSCode's
    screenkey # Show pressed keys on screen
    silver-searcher # Blazingly fast, multi-CPU-core, ack-like searcher
    sxiv # View pictures
    tdesktop # Telegram
    texlive.combined.scheme-medium # Latex
    tmux
    xorg.xev # Check keys' names
    xwallpaper # Set wallpapers
    zathura # GOAT PDF viewer
    zsh
  ];

  xsession = {
    enable = true;

    windowManager.bspwm = {
      enable = true;

      monitors = {
        eDP = [ "α" "β" "γ" "δ" "ε" "ζ" "η" "θ" ];
      };

      settings = {
        border_width = 0;
        window_gap = 12;

        focus_follows_pointer = true;
        pointer_follows_focus = true;
      };

      rules = {
        # For some reason they spawn "floating" by default
        "Zathura" = { state = "tiled"; };
        "Sxiv" = { state = "tiled"; };
      };

      startupPrograms = [
        "systemctl --user restart polybar"
      ];
    };

    # Setup keyboard speed so that when holding a button for 0.3 sec, 50 chars
    # will be printed
    initExtra = ''
      xset r rate 300 50
      xwallpaper --zoom ~/.background-image
    '';
  };

  services.sxhkd = {
    enable = true;

    keybindings = {
      "super + Return" = TERM;
      "super + m" = "pactl set-source-mute @DEFAULT_SOURCE@ toggle"; # Mute mic
      "super + r" = TERM + "-e htop";
      "super + shift + m" = "pamixer -t"; # Toggle mute audio
      "super + shift + r" = TERM + "-e lf"; # r for ranger
      "super + shift + w" = TERM + "-e nmtui"; # Network Manager GUI
      "super + shift + {1-8}" = "bspc node -d '^{1-8}'";
      "super + shift + {Down,Up}" = "brightnessctl set {5-,+5}";
      "super + shift + {h,j,k,l}" = "bspc node -s {west,south,north,east}";
      "super + w" = "firefox";
      "super + {1-8}" = "bspc desktop -f '^{1-8}'";
      "super + {f,t,+ shift + f}" = "bspc node -t {fullscreen,tiled,floating}";
      "super + {h,j,k,l}" = "bspc node -f {west,south,north,east}";
      "super + {minus,equal}" = "pamixer -{d,i} 5";
      "super + {q,+ shift + q}" = "bspc node -{c,k}"; # Close/Kill node
      # "super + shift + s" = "killall screenkey || screenkey &"; # Show keys
      "super + d" = "rofi -show drun";
    };
  };

  # Ricing
  services.picom = {
    enable = true;

    # fade = true;
    # shadow = true;
    # settings = {
    #   blur = {
    #     method = "gaussian";
    #     size = 10;
    #     deviation = 5.0;
    #   };
    # };

    inactiveOpacity = 0.8;
  };

  services.polybar = {
    enable = true;

    # package = pkgs.polybar.override {
    #   pulseSupport = true;
    # };

    config = {
      "colors" = {
        background = "#282A2E";
        background-alt = "#373B41";
        foreground = "#C5C8C6";
        primary = "#2C78BF";
        secondary = "#68A8E4";
        alert = "#EF2F27";
        disabled = "#707880";
      };

      "bar/main" = {
        width = "100%";
        height = "24pt";
        radius = "6";

        background = "\${colors.background}";
        foreground = "\${colors.foreground}";

        line-size = "3pt";
        border-size = "4pt";
        border-color = "#00000000";

        padding-left = "0";
        padding-right = "1";

        module-margin = "1";

        separator = "|";
        separator-foreground = "\${colors.disabled}";

        font-0 = "monospace;2";

        modules-left = "xworkspaces xwindow";
        modules-center = "date";
        modules-right = "memory cpu custompulse wlan battery xkeyboard";

        cursor-click = "pointer";
        cursor-scroll = "ns-resize";

        enable-ipc = "true";
      };

      "module/xworkspaces" = {
        type = "internal/xworkspaces";

        label-active = "%name%";
        label-active-background = "\${colors.background-alt}";
        label-active-underline = "\${colors.primary}";
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
        date-alt = "%Y-%m-%d %H:%M:%S";

        label = "%date%";
        label-foreground = "\${colors.foreground}";
      };

      "network-base" = {
        type = "internal/network";
        interval = "5";
        format-connected = "<label-connected>";
        format-disconnected = "<label-disconnected>";
        label-disconnected = "{F#68A8E4}%ifname%%{F#707880} disconnected";
      };

      "module/wlan" = {
        "inherit" = "network-base";
        interface-type = "wireless";
        label-connected = "%{F#68A8E4}%ifname%%{F-} %essid%";
      };

      "module/memory" = {
        type = "internal/memory";
        interval = "2";
        format-prefix = "RAM ";
        format-prefix-foreground = "\${colors.secondary}";
        label = "%percentage_used:2%%";
      };

      "module/cpu" = {
        type = "internal/cpu";
        interval = "2";
        format-prefix = "CPU ";
        format-prefix-foreground = "\${colors.secondary}";
        label = "%percentage:2%%";
      };

      "module/pulseaudio" = {
        type = "internal/pulseaudio";

        format-volume-prefix = "\"VOL \"";
        format-volume-prefix-foreground = "\${colors.primary}";
        format-volume = "<label-volume>";

        label-volume = "%percentage%%";

        label-muted = "muted";
        label-muted-foreground = "\${colors.disabled}";
      };

      "module/custompulse" = {
        # TODO: make exec dir relative;
        # create colors (disabled for muted), 
        type = "custom/script";
        interval = "2";
        # tail = "true"; # eats so much
        exec = "~/.config/nixpkgs/custompulse.sh";

        format-prefix = "VOL ";
        format-prefix-foreground = "\${colors.secondary}";

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

        label-layout = "%layout%";
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

  programs.zsh = {
    enable = true;

    shellAliases = {
      D = "cd ~/Downloads && l";
      c = "cd ~/Code && l";
      cf = "cd ~/.config && l";
      cfa = EDITOR + "~/.config/alacritty/alacritty.yml";
      cfn = EDITOR + "~/.config/nixpkgs/home.nix";
      cfs = "sudo" + EDITOR + "/etc/nixos/configuration.nix";
      cp = "cp -iv";
      d = "cd ~/Documents && l";
      mm = "pactl set-source-mute @DEFAULT_SOURCE@ toggle"; # Mute mic
      mv = "mv -iv";
      nrs = "sudo nixos-rebuild switch";
      p = "cd ~/Pictures && l";
      rm = "rm -vI";
      sc = "cd ~/Pictures/Screenshots && l";
      tg = "telegram-desktop";
      u = "cd ~/University && l";
      z = "zathura";
    };

    oh-my-zsh = {
      enable = true;

      plugins = [ "git" "python" "man" "ag" "vi-mode" ];
      # theme = "darkblood";
      theme = "half-life"; # Gordon Freeman saved my life
    };
  };

  programs.zathura = {
    enable = true;

    # Standard mappings are kind of retarded
    extraConfig = ''
      set sandbox none;
      set statusbar-h-padding 0
      set statusbar-v-padding 0
      set page-padding 1
      set selection-clipboard clipboard
      map u scroll half-up
      map d scroll half-down
      map U scroll full-up
      map D scroll full-down
      map r reload
      map R rotate
      map K zoom in
      map J zoom out
      map i recolor
      map p print
      map g goto top
    '';
  };

  programs.rofi = {
    enable = true;

    extraConfig = {
      modi = "drun";
    };

    terminal = "${pkgs.alacritty}/bin/alacritty";

    theme = "Arc";
  };

  programs.git = {
    enable = true;
    userName = "Konstantin Runov";
    userEmail = "runebone1@gmail.com";
  };

  programs.home-manager.enable = true;
}
