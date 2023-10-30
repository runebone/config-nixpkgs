{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;

    history = {
      size = 100000;
      save = 100000;
    };

    initExtra = ''
      # export ZSH_CUSTOM=/nix/var/nix/gcroots/per-user-human/current-home/home-path/share/zsh
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/nix/var/nix/profiles/per-user/human/profile/lib
      export PATH=$PATH:/nix/var/nix/profiles/per-user/human/profile/include

      # Luke Smith's .zshrc

      autoload -U colors && colors

      # Use vim keys in tab complete menu:
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey -M menuselect 'j' vi-down-line-or-history
      bindkey -v '^?' backward-delete-char

      # Change cursor shape for different vi modes.
      function zle-keymap-select () {
          case $KEYMAP in
              vicmd) echo -ne '\e[1 q';;      # block
              viins|main) echo -ne '\e[5 q';; # beam
          esac
      }
      zle -N zle-keymap-select
      zle-line-init() {
          zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
          echo -ne "\e[5 q"
      }
      zle -N zle-line-init
      echo -ne '\e[5 q' # Use beam shape cursor on startup.
      preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

      # Use lf to switch directories and bind it to ctrl-o
      lfcd () {
          tmp="$(mktemp)"
          lf -last-dir-path="$tmp" "$@"
          if [ -f "$tmp" ]; then
              dir="$(cat "$tmp")"
              rm -f "$tmp" >/dev/null
              [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
          fi
      }
      bindkey -s '^o' 'lfcd\n'

      bindkey -s '^a' 'bc -lq\n'

      bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'

      bindkey '^[[P' delete-char

      # Edit line in vim with ctrl-e:
      autoload edit-command-line; zle -N edit-command-line
      bindkey '^e' edit-command-line
    '';

    shellAliases = {
      D = "cd ~/Downloads && l";
      b = "cd ~/Books && l";
      c = "cd ~/Code && l";
      cb = "cd ~/Code/bmstu && l";
      cdcd = "cd ~/.config/home-manager && l";
      cdn = "cd ~/.config/home-manager/neovim && l";
      cf = "cd ~/.config && l";
      cfcf = "cd ~/.config/home-manager && l";
      cfnp = "cd ~/.config/home-manager && l";
      cfa = "vim ~/.config/alacritty/alacritty.yml";
      cfh = "vim ~/.config/home-manager/home.nix";
      cfn = "vim ~/.config/home-manager/neovim/neovim.nix";
      cfm = "vim ~/.config/home-manager/neovim/main.lua";
      cfp = "vim ~/.config/home-manager/polybar.nix";
      cfs = "sudo vim /etc/nixos/configuration.nix";
      cfz = "vim ~/.config/home-manager/zsh.nix";
      cp = "cp -iv";
      d = "cd ~/Documents && l";
      hm = "home-manager";
      ls = "ls -h --color=auto --group-directories-first";
      mkdir = "mkdir -pv";
      mm = "pactl set-source-mute @DEFAULT_SOURCE@ toggle"; # Mute mic
      mv = "mv -iv";
      nrs = "sudo nixos-rebuild switch";
      ngc = "nix-store --gc";
      p = "cd ~/Pictures && l";
      rm = "rm -vI";
      sc = "cd ~/Pictures/Screenshots && l";
      sxiv = "devour sxiv"; # Swallow terminal
      tg = "devour telegram-desktop";
      u = "cd ~/University && l";
      z = "devour zathura"; # Swallow terminal
      zathura = "devour zathura"; # Swallow terminal
      qtcreator = "devour qtcreator"; # Swallow terminal
      blender = "devour blender"; # Swallow terminal
      obs = "devour obs"; # Swallow terminal
      gimp = "devour gimp"; # Swallow terminal
      brave = "devour brave"; # Swallow terminal
      # asm = "cd ~/University/asm && l";
      # ca = "cd ~/University/compalg && l";
      ae = "cd ~/University/s4/archcomp && l";
      # cg = "cd ~/University/cg && l";
      oop = "cd ~/University/s4/oop && l";
      v = "devour neovide --nofork --multigrid";
      # vim = "devour neovide --nofork --multigrid";
      # psci = "cd ~/University/polsci && l";
      # ssci = "cd ~/University/socsci && l";
      # lta = "cd ~/University/lta && l";
      # de = "cd ~/University/deutsche && l";
      aa = "cd ~/University/aa && l";
      db = "cd ~/University/db && l";
      os = "cd ~/University/os && l";
      pt = "cd ~/University/probtheory && l";
      nir = "cd ~/University/nir && l";
      cg = "cd ~/University/cg-cw-s4-bmstu && l";
      translit = "python ~/.config/home-manager/scripts/translit.py";
      dn = "vim ~/Notes/$(date +'%Y-%m-%d').md";
      sdn = "shutdown now";
      setrbg = "sh ~/.config/home-manager/scripts/set_random_background.sh";
      sbg = "xwallpaper --zoom";
      wp = "cd ~/Pictures/Wallpapers && l";
      ssh = "TERM=xterm-256color ssh";
      qrd = "devour qrenderdoc";
      lo = "devour libreoffice";
      vpn = "sudo openvpn --config ~/University/bmstu.ovpn";
      anki = "devour anki";
      xpp = "devour xournalpp";
      ast = "devour android-studio-dev";
      enw = "emacs -nw";
    };

    plugins = [
        {
          name = "zsh-fast-syntax-highlighting";
          src = pkgs.zsh-fast-syntax-highlighting;
          file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
        }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "man" "ag" "vi-mode" ];
      theme = "half-life"; # Gordon Freeman saved my life
      # theme = "lambda-mod"; # Gordon Freeman saved my life
    };
  };
}
