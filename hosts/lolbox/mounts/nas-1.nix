{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.cifs-utils ];

  sops.secrets."nas-1/tahia" = {
    mode = "0600";
    path = "/home/tahia/.nas-1";
  };

  system.activationScripts.createNas1Dir = {
    text = ''
      mkdir -p /home/tahia/mnt/nas-1
      chown 1000:1000 /home/tahia/mnt/nas-1
    '';
  };

  fileSystems."/home/tahia/mnt/nas-1" = {
    device = "//192.168.2.34/backpack";
    fsType = "cifs";
    options =
      let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in
      [ "${automount_opts},credentials=/home/tahia/.nas-1,uid=1000,gid=100" ];
  };
}
