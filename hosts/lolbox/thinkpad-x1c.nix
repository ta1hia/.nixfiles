{ lib, ... }:

{
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true; # Might help wifi?

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  services.xserver = {
    dpi = 210;
    displayManager.sessionCommands = ''
      xrandr --output eDP-1 --scale 1.5x1.5
    '';
    displayManager.lightdm.greeters.gtk.cursorTheme.size = 50;
  };


  services.xserver.monitorSection = ''
    DisplaySize 310 174   # In millimeters
  '';

  services.xserver.videoDrivers = [ "modesetting" ];
  #services.xserver.deviceSection = ''
  #  Option "Backlight" "intel_backlight"  # Maybe unnecessary?

  #  Option "DRI" "2"

  #  # DRI 3 with default AccelMethod causes rendering issues after sleep/resume
  #  # with some GPU-accelerated 2D apps (like Electron/Alacritty). It does work
  #  # with the older "UXA" AccelMethod, but there's a 1-2s lag switching
  #  # desktops to Chrome. Upside is DRI 3 has better Vulkan support?
  #  #Option "DRI" "3"
  #  #Option "AccelMethod" "UXA"  # Default is the newer "SNA", see note above.
  #  #Option "TearFree" "true"
  #'';

  services.libinput = {
    enable = true;
    touchpad = {
      disableWhileTyping = true;
      accelSpeed = "0.25";
      clickMethod = "clickfinger";
    };

    mouse = {
      scrollMethod = "button";
      scrollButton = 2;
      horizontalScrolling = false;
      accelProfile = "flat";
    };

  };

  services.tlp.enable = true;
  services.tlp.settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "powersave";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    START_CHARGE_THRESH_BAT0 = 75;
    STOP_CHARGE_THRESH_BAT0 = 90;
  };

  # Firmware updating
  services.fwupd.enable = true;

  # Disable the "throttling bug fix" -_- https://github.com/NixOS/nixos-hardware/blob/master/common/pc/laptop/cpu-throttling-bug.nix
  systemd.timers.cpu-throttling.enable = lib.mkForce false;
  systemd.services.cpu-throttling.enable = lib.mkForce false;
}
