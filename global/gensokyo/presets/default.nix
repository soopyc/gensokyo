{lib, ...}: {
  imports = [
    ./vmetrics.nix
    ./nginx.nix
    ./certificates.nix
    ./secureboot.nix
  ];

  options.gensokyo.presets = {
    vmetrics = lib.mkEnableOption "vmetrics presets";
    nginx = lib.mkEnableOption "nginx presets";
    certificates = lib.mkEnableOption "boilerplate certificate issuing presets";
    secureboot = lib.mkEnableOption "configuration of secureboot related options";
  };
}
