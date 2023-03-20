{ config, lib, pkgs, ... }:

with {
  join = list: lib.concatStringsSep " " list;

  EDITOR = "vim";
  BROWSER = "firefox";
  TERM = "alacritty";
};

# TODO: make this file cleaner
let
  my-python-packages = ps: with ps; [
    beautifulsoup4
    matplotlib
    numpy
    pandas
    pip
    poetry # Virtual environments, dependencies management
    requests
    scipy
    sympy
  ];
in
{
  imports = [
    ./neovim/neovim.nix
    ./polybar.nix
    ./zathura.nix
    ./zsh.nix
  ];

  home = {
    username = "human";
    homeDirectory = "/home/human";
    sessionVariables = {
      EDITOR = EDITOR;
      BROWSER = BROWSER;
      TERMINAL = TERM;
    };
    stateVersion = "22.11";
  };

  home.packages = with pkgs; [
    (python3.withPackages my-python-packages)
    alacritty
    anki
    blender
    brightnessctl
    clang-tools # C/C++ language server
    cmake
    devour # Window swallowing; hides your current window when launching an external program
    firefox
    fzf
    gcc
    gdb # GNU debugger
    gimp
    git
    gnumake
    go
    gopls # Go language server
    helix
    htop
    killall
    lf # CLI file manager
    libGL # OpenGL stuff
    libreoffice-qt # Open docx
    maim # "make image"; for screenshots
    mpv # Open video-files
    neofetch # Of course
    neovide # Neovim GUI
    obs-studio
    ocrmypdf
    pamixer # PulseAudio mixer
    picom # Ricing
    polybar
    pyright # Python language server
    qt6.full
    qtcreator # Qt's vim is actually faster than VSCode's
    ripgrep # Blazingly fast recursive grep
    rnix-lsp # Nix language server
    rust-analyzer # Rust language server
    rustup # Rust compiler + cargo + rustup
    screenkey # Show pressed keys on screen
    sxiv # View pictures
    tdesktop # Telegram
    texlive.combined.scheme-medium # Latex
    translate-shell
    transmission
    unzip
    xorg.libX11 # OpenGL stuff
    xorg.libXi
    xorg.libXrandr
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
        window_gap = 0;

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
      "Print" = "_PATH_=\"\$HOME/Pictures/Screenshots/pic-full-\"\$(date '+%y%m%d-%H%M-%S').png\"\" && maim \"$_PATH_\" && xclip -selection clipboard -t image/png \"$_PATH_\"";
      "super + Print" = "_PATH_=\"\$HOME/Pictures/Screenshots/pic-sel-\"\$(date '+%y%m%d-%H%M-%S').png\"\" && maim -s \"$_PATH_\" && xclip -selection clipboard -t image/png \"$_PATH_\"";
      "super + shift + s" = "systemctl suspend";
      "super + End" = "systemctl hibernate";
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
