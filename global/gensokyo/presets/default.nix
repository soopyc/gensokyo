{lib, ...}: {
  imports = [
    ./vmetrics.nix
    ./nginx.nix
    ./certificates.nix
  ];

  options.gensokyo.presets = {
    vmetrics = lib.mkEnableOption "vmetrics presets";
    nginx = lib.mkEnableOption "nginx presets";
    certificates = lib.mkEnableOption "boilerplate certificate issuing presets";
  };
}
