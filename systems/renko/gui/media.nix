{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.obs-studio
  ];
}
