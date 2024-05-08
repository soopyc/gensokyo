{lib, ...}: {
  imports = [
    ./vmagent.nix
  ];

  options.gensokyo.presets = {
    vmagent = lib.mkEnableOption "vmagent presets";
  };
}
