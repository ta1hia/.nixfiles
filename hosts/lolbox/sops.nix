# host-level sops. todo: move to access keys derived from ssh.

{ ... }:
{
  sops = {
    age.keyFile = "/home/tahia/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets.yaml;
  };
}
