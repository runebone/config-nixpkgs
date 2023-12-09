{ config, lib, pkgs, ... }:

with {
  join = list: lib.concatStringsSep " " list;

  EDITOR = "vim";
  BROWSER = "brave";
  TERM = "alacritty";
};

# TODO: make this file cleaner
let
  my-python-packages = ps: with ps; [
    jupyter
    ipython
    beautifulsoup4
    matplotlib
    numpy
    pandas
    pip
    pyqt6
    poetry-core # Virtual environments, dependencies management
    requests
    scipy
    sympy
    psycopg2
    faker
    redis
  ];
  unstableTarball = 
  fetchTarball
  https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
in
{
  imports = [
    ./neovim/neovim.nix
    ./polybar.nix
    ./zathura.nix
    ./zsh.nix
  ];

  nixpkgs.config = {
    packageOverrides = pkgs: with pkgs; {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  home = {
    username = "human";
    homeDirectory = "/home/human";
    sessionVariables = {
      EDITOR = EDITOR;
      BROWSER = BROWSER;
      TERMINAL = TERM;
    };
    stateVersion = "23.05";
  };

  home.packages = with pkgs; [
    emacs
    emacsPackages.doom
    # tikzit
    # lambda-mod-zsh-theme
    rnote # ~= xournalpp
    # vimb
    # vimgolf
    activate-linux
    alacritty
    anki
    blender
    brave
    brightnessctl
    colorpicker
    devour # Window swallowing; hides your current window when launching an external program
    dia
    docker
    docker-compose
    dosbox
    dot2tex
    file
    firefox
    # librewolf-unwrapped
    fzf
    gimp
    groff
    htop
    killall
    kitty
    lf # CLI file manager
    libreoffice-qt # Open docx
    # linuxKernel.packages.linux_zen.virtualboxGuestAdditions
    maim # "make image"; for screenshots
    man-pages # Linux manual
    mpv # Open video-files
    neofetch # Of course
    neovide # Neovim GUI
    nmap
    obs-studio
    openvpn
    pamixer # PulseAudio mixer
    parallel # Parallelize shell commands execution
    picom # Ricing
    pkg-config
    polybar
    qt6.full
    qtcreator # Qt's vim is actually faster than VSCode's
    ripgrep # Blazingly fast recursive grep
    screenkey # Show pressed keys on screen
    sxiv # View pictures
    tdesktop # Telegram
    texlive.combined.scheme-full # Latex
    translate-shell
    transmission
    unzip
    xorg.xev # Check keys' names
    xorg.xfontsel
    xorg.xmodmap
    xwallpaper # Set wallpapers
    zathura # GOAT PDF viewer
    zip
    zsh

    # PDF stuff
    imagemagick
    ocrmypdf
    pandoc
    poppler_utils # pdfunite
    xournalpp

    # Web stuff
    nodePackages.eslint
    nodePackages.prettier
    nodePackages.svelte-language-server
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodejs
    bun
    vite

    # Android stuff
    jdk # OpenJDK
    # unstable.android-studio
    # android-studio
    # androidStudioPackages.dev
    # androidStudioPackages.canary
    unstable.androidStudioPackages.dev
    gradle
    qemu
    libvirt # kvm
    bridge-utils # kvm
    kotlin
    kotlin-language-server

    # Programming languages
    (python3.withPackages my-python-packages)
    clisp
    go
    julia
    rustup # Rust compiler + cargo + rustup

    # Language servers
    clang-tools # C/C++ language server
    gopls # Go language server
    pyright # Python language server
    rnix-lsp # Nix language server
    # rust-analyzer # Rust language server
    jdt-language-server # Java...

    # Misc for programming
    astyle
    cmake
    gcc
    git
    gnumake
    gnuplot
    nasm
    ninja # Build system for cmake
    streamlit
    tmux
    glxinfo # OpenGL info

    # Libraries
    # vulkan-loader # Rust GLs
    boost # Boost/Asio C++ lib
    eigen # Linear algebra template lib
    glfw
    glm
    gtest
    gtk3
    libGL # OpenGL stuff
    nlohmann_json # C++ json lib
    xorg.libX11 # OpenGL stuff
    xorg.libXi
    xorg.libXinerama # Use 2 or more physical displays as one large display
    xorg.libXrandr
    xorg.libxcb

    # Testing
    bazel

    # Debuggers
    gdb # GNU debugger
    cgdb # Pretty nice
    renderdoc # Graphics debugger
    apitrace # Another graphics debugger
    edb # ~ IDA Pro; x64dbg
    delve # Golang debugger

    # Profiling stuff
    gperftools
    gprof2dot
    graphviz
    heaptrack
    hotspot
    libsForQt5.kcachegrind
    linuxKernel.packages.linux_5_15.perf
    valgrind
    tracy
    massif-visualizer

    # SDL2 stuff
    SDL2
    SDL2_gfx
    SDL2_image
    SDL2_mixer
    SDL2_net
    SDL2_sound
    SDL2_ttf
  ];

  xsession = {
    enable = true;

    windowManager.bspwm = {
      enable = true;

      # monitors = [ 1 2 3 4 5 6 7 8 ]; # {
        # eDP = [ "α" "β" "γ" "δ" "ε" "ζ" "η" "θ" ];
        # eDP = [ "1" "2" "3" "4" "5" "6" "7" "8" ];
        # eDP = [ "" "" "" "" "" "" "" "" ];
      # };

      settings = {
        border_width = 0;
        window_gap = 0;

        focus_follows_pointer = true;
        # pointer_follows_focus = true;
      };

      rules = {
        # For some reason they spawn "floating" by default
        "Zathura" = { state = "tiled"; };
        "Sxiv" = { state = "tiled"; };
      };

      startupPrograms = [
        "systemctl --user restart polybar"
      ];

      extraConfig = ''
      bspc monitor -d 1 2 3 4 5 6 7 8
      '';
    };

    # Setup keyboard speed so that when holding a button for 0.3 sec, 50 chars
    # will be printed
    initExtra = ''
      xset r rate 300 50
      xrandr --output eDP --set "TearFree" on
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
      "super + e" = "firefox";
      "super + w" = BROWSER;
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
      "super + bracketleft" = "bspc node -z left -120 0 || bspc node -z right -120 0";
      "super + bracketright" = "bspc node -z left 120 0 || bspc node -z right 120 0";
      "super + l" = "sh ~/.config/home-manager/scripts/switch_layout.sh";
    };
  };

  # Ricing
  services.picom = {
    enable = true;

    backend = "xrender";

    inactiveOpacity = 0.95;
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

  programs.tmux = {
    enable = true;

    extraConfig = ''
    '';
  };

  programs.lf = {
    enable = true;

    extraConfig = ''
    # define a custom "delete" command
    # $fx - selected with "space" files (marked pink)
    cmd delete ''${{
    set -f
    printf "$fx\n"
    printf "delete?[y/n]"
    read ans
    [ $ans = "y" ] && rm -rf $fx
    }}

    map D delete
    '';
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
  builtins.elem (lib.getName pkg) [
    "android-studio-stable"
    "android-studio-dev"
    "android-studio-canary"
  ];

  programs.home-manager.enable = true;
}
