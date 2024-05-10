{pkgs, ...}: {
  # other devices support modules

  hardware.keyboard.qmk.enable = true;
  environment.systemPackages = [
    pkgs.via
  ];

  programs.kdeconnect.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  # services.blueman.enable = true;
}
