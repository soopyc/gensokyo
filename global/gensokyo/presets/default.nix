{lib, ...}: {
  imports = [
    ./buildbot.nix
    ./vmetrics.nix
    ./nginx.nix
    ./certificates.nix
    ./secureboot.nix
  ];

  options.gensokyo.presets = {
    buildbot = lib.mkEnableOption "buildbot presets";
    vmetrics = lib.mkEnableOption "vmetrics presets";
    nginx = lib.mkEnableOption "nginx presets";
    certificates = lib.mkEnableOption "boilerplate certificate issuing presets";
    secureboot = lib.mkEnableOption "configuration of secureboot related options";
  };
}
