{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;

    shellAliases = {
      D = "cd ~/Downloads && l";
      c = "cd ~/Code && l";
      cf = "cd ~/.config && l";
      cfa = "vim ~/.config/alacritty/alacritty.yml";
      cfn = "vim ~/.config/nixpkgs/home.nix";
      cfs = "sudo vim /etc/nixos/configuration.nix";
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
}
