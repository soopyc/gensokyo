{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.vlc
    pkgs.thunderbird
  ];
}
