{...}: {
  programs.firefox.enable = true;

  programs.chromium.enable = true;
  security.chromiumSuidSandbox.enable = true;
}
