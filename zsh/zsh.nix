{ config, pkgs, ... }:

let
  homeManagerDir = "~/.config/home-manager";
in
{
  programs.zsh = {
    enable = true;

    history = {
      size = 100000;
      save = 100000;
    };

    initExtra = ''
      source ${homeManagerDir}/zsh/lukesmith.zshrc
      source ${homeManagerDir}/zsh/zoxide.zshrc
    '';

    shellAliases = {
      D = "cd ~/Downloads && l";
      b = "cd ~/Books && l";
      c = "cd ~/Code && l";
      cb = "cd ~/Code/bmstu && l";
      cba = "cd ~/Code/bmstu/aa && l";
      cdcd = "cd ${homeManagerDir} && l";
      cdn = "cd ${homeManagerDir}/neovim && l";
      cf = "cd ~/.config && l";
      cfcf = "cd ${homeManagerDir} && l";
      cfnp = "cd ${homeManagerDir} && l";
      cfa = "vim ~/.config/alacritty/alacritty.yml";
      cfh = "vim ${homeManagerDir}/home.nix";
      cfn = "vim ${homeManagerDir}/neovim/neovim.nix";
      cfm = "vim ${homeManagerDir}/neovim/main.lua";
      cfp = "vim ${homeManagerDir}/polybar.nix";
      cfs = "sudo vim /etc/nixos/configuration.nix";
      cfz = "vim ${homeManagerDir}/zsh/zsh.nix";
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
      s = "devour zathura"; # Swallow terminal
      zathura = "devour zathura"; # Swallow terminal
      qtcreator = "devour qtcreator"; # Swallow terminal
      blender = "devour blender"; # Swallow terminal
      obs = "devour obs"; # Swallow terminal
      gimp = "devour gimp"; # Swallow terminal
      brave = "devour brave"; # Swallow terminal
      drawio = "devour drawio";
      v = "cd ~/Videos && l";
      pp = "cd ~/Papers && l";

      oop = "cd ~/University/s4/oop && l";
      cg = "cd ~/University/s5/cg-cw-s4-bmstu && l";
      nir = "cd ~/University/s5/nir && l";
      aa = "cd ~/University/s5/aa && l";
      db = "cd ~/University/db-cw-s6-bmstu && l";
      os = "cd ~/University/os && l";
      f = "cd ~/University/falp && l";
      m = "cd ~/University/modeling && l";
      ms = "cd ~/University/ms && l";
      ppo = "cd ~/University/ppo && l";
      sd = "cd ~/University/software-design && l";
      de = "cd ~/University/deutsche && l";

      translit = "python ${homeManagerDir}/scripts/translit.py";
      dn = "vim ~/Notes/$(date +'%Y-%m-%d').md";
      sdn = "shutdown now";
      setrbg = "sh ${homeManagerDir}/scripts/set_random_background.sh";
      sbg = "xwallpaper --zoom";
      wp = "cd ~/Pictures/Wallpapers && l";
      wpp = "cd ~/Pictures/wp230224 && l";
      ssh = "TERM=xterm-256color ssh";
      qrd = "devour qrenderdoc";
      lo = "devour libreoffice";
      vpn = "sudo openvpn --config ~/University/bmstu.ovpn";
      anki = "devour anki";
      xpp = "devour xournalpp";
      ast = "devour android-studio-dev";
      enw = "emacs -nw";
      t = "/var/run/current-system/sw/bin/time";
      sl = "ls";
      no = "ls";
      rdms = "systemctl restart display-manager.service";
      sbcl = "rlwrap sbcl";
      vb = "devour VirtualBox";
      nv = "devour neovide --multigrid --nofork";
      jp = "julia --project";
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
