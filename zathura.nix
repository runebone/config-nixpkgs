{ config, pkgs, ... }:
{
  programs.zathura = {
    enable = true;

    # Standard mappings are kind of retarded
    extraConfig = ''
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
      set sandbox none
    '';
    # set sandbox none to enable links following
  };
}
