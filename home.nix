{ config, lib, pkgs, ... }:

with {
  join = list: lib.concatStringsSep " " list;

  EDITOR = "vim";
  BROWSER = "firefox";
  TERM = "alacritty";
};

{
  imports = [
    ./polybar.nix
    ./zsh.nix
    ./zathura.nix
  ];

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
      "super + r" = join [ TERM "-e htop" ];
      "super + shift + m" = "pamixer -t"; # Toggle mute audio
      "super + shift + r" = join [ TERM "-e lf" ]; # r for ranger
      "super + shift + w" = join [ TERM "-e nmtui" ]; # Network Manager GUI
      "super + shift + {1-8}" = "bspc node -d '^{1-8}'";
      "super + shift + {Down,Up}" = "brightnessctl set {5-,+5}";
      "super + shift + {h,j,k,l}" = "bspc node -s {west,south,north,east}";
      "super + w" = "firefox";
      "super + {1-8}" = "bspc desktop -f '^{1-8}'";
      "super + {f,t,+ shift + f}" = "bspc node -t {fullscreen,tiled,floating}";
      "super + {h,j,k,l}" = "bspc node -f {west,south,north,east}";
      "super + {minus,equal}" = "pamixer -{d,i} 5";
      "super + {q,+ shift + q}" = "bspc node -{c,k}"; # Close/Kill node
      "super + d" = "rofi -show drun";
    };
  };

  # Ricing
  services.picom = {
    enable = true;

    inactiveOpacity = 0.8;
  };

  programs.rofi = {
    enable = true;

    extraConfig = { modi = "drun"; };
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
