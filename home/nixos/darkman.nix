{ ... }:

{
  services.darkman = {
    enable = true;
    settings = {
      usegeoclue = true;
      dbusserver = true;
      portal = true;
    };

    # note: use the `kitten themes` selector gui outside of tmux with L + D 
    # to select new themes
    lightModeScripts = {
      kitty = ''
        /etc/profiles/per-user/tahia/bin/kitty @ --to unix:/run/user/1000/kitty.socket set-colors --all --config /home/tahia/.config/kitty/light-theme.auto.conf
      '';
    };
    darkModeScripts = {
      kitty = ''
        /etc/profiles/per-user/tahia/bin/kitty @ --to unix:/run/user/1000/kitty.socket set-colors --all --config /home/tahia/.config/kitty/dark-theme.auto.conf
      '';
    };
  };
}
