{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    package = pkgs.floorp;
  };

  security.chromiumSuidSandbox.enable = true;
}
