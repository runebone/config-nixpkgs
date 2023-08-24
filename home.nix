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
    colorpicker
    # lambda-mod-zsh-theme
    activate-linux
    # subversion # svn version control
    # rnote # ~= xournalpp
    SDL2
    SDL2_ttf
    SDL2_net
    SDL2_gfx
    SDL2_sound
    SDL2_mixer
    SDL2_image
    # assimp # Open Asset Import Library (for OpenGL)
    zip
    nodejs
    nodePackages.svelte-language-server
    nodePackages.typescript
    nodePackages.typescript-language-server
    poppler_utils # pdfunite
    nlohmann_json
    boost # boost/asio c++ lib
    qemu
    slock
    # vimb
    # vimgolf
    parallel # Parallelize shell commands execution
    edb # ~ IDA Pro; x64dbg
    gtk3
    brave
    tmux
    streamlit
    docker
    docker-compose
    nasm
    imagemagick
    astyle
    glfw
    glm
    pkg-config
    (python3.withPackages my-python-packages)
    alacritty
    anki
    blender
    brightnessctl
    clang-tools # C/C++ language server
    clisp
    cmake
    devour # Window swallowing; hides your current window when launching an external program
    dosbox
    firefox
    fzf
    gcc

    # Debuggers
    gdb # GNU debugger
    ddd # GDB frontend
    # lldb # LLVM debugger
    renderdoc # Graphics debugger
    apitrace # Another graphics debugger
    kdbg # Didn't like it
    cgdb # Pretty nice
    # gdbgui # Doesn't work, WERKZEUG server error

    # Profiling stuff
    gprof2dot
    graphviz
    linuxKernel.packages.linux_5_15.perf
    valgrind
    hotspot
    heaptrack
    gperftools
    libsForQt5.kcachegrind

    gimp
    git
    gnumake
    go
    gopls # Go language server
    helix
    htop
    julia
    killall
    lf # CLI file manager
    libGL # OpenGL stuff
    libreoffice-qt # Open docx
    maim # "make image"; for screenshots
    mpv # Open video-files
    neofetch # Of course
    neovide # Neovim GUI
    nmap
    obs-studio
    ocrmypdf
    pamixer # PulseAudio mixer
    pandoc
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
    texlive.combined.scheme-full # Latex
    tmux
    translate-shell
    transmission
    unzip
    # vulkan-loader # Rust GLs
    xorg.libX11 # OpenGL stuff
    xorg.libXi
    xorg.libXrandr
    xorg.xev # Check keys' names
    xorg.xmodmap
    xorg.libxcb
    xorg.xfontsel
    # xorg.libXinerama
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

  programs.home-manager.enable = true;
}
