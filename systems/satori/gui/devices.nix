{pkgs, ...}: {
  # other devices support modules

  hardware.keyboard.qmk.enable = true;
  environment.systemPackages = [
    pkgs.via
  ];
}
