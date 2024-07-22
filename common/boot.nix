{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # LUKS
  boot.initrd.luks.devices = {
    root = { device = "/dev/nvme0n1p2"; allowDiscards = true; preLVM = true; };
  };
}
