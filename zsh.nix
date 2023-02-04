{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;

    history = {
      size = 100000;
      save = 100000;
    };

    initExtra = ''
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
      c = "cd ~/Code && l";
      cf = "cd ~/.config && l";
      cfa = "vim ~/.config/alacritty/alacritty.yml";
      cfh = "vim ~/.config/nixpkgs/home.nix";
      cfn = "cd ~/.config/nixpkgs && l";
      cfp = "vim ~/.config/nixpkgs/polybar.nix";
      cfs = "sudo vim /etc/nixos/configuration.nix";
      cfz = "vim ~/.config/nixpkgs/zsh.nix";
      cp = "cp -iv";
      d = "cd ~/Documents && l";
      ls = "ls --color --group-directories-first";
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

    plugins = [
        {
          name = "zsh-fast-syntax-highlighting";
          src = pkgs.zsh-fast-syntax-highlighting;
          file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
        }
    ];

    # oh-my-zsh = {
    #   enable = true;

    #   plugins = [ "git" "man" "ag" "vi-mode" ];
    #   theme = "half-life"; # Gordon Freeman saved my life
    # };
  };
}
