{lib, ...}: {
  imports = [
    ./vmetrics.nix
  ];

  options.gensokyo.presets = {
    vmetrics = lib.mkEnableOption "vmetrics presets";
  };
}
