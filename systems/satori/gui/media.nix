{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.vlc
    pkgs.obs-studio
  ];
}
