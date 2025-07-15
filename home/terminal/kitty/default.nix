{ config, pkgs, ... }:
{
  programs.kitty = {
    enable = true;

    # Optional: extra config in raw text (appended to kitty.conf)
    extraConfig = ''
      confirm_os_window_close 0
      enable_audio_bell no
    '';
  };

  xdg.configFile."kitty/kitty.conf".source = ./kitty.conf;
  xdg.configFile."kitty/current-theme.conf".source = ./current-theme.conf;
}
