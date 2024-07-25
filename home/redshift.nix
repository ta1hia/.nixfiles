{ config, pkgs, ... }:

{
  services.redshift = {
    enable = false;
    latitude = "43.6532";
    longitude = "79.3832";
  };
}
