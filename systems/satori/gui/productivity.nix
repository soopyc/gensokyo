{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.thunderbird
  ];
}
