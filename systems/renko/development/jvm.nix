{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.jetbrains.idea-ultimate
  ];
}
