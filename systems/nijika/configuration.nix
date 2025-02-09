{inputs, ...}: {
  imports = [
    ./services
    ./networking.nix # generated at runtime by nixos-infect
  ];

  gensokyo.presets = {
    vmetrics = true;
    certificates = true;
    nginx = true;
  };
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  system.stateVersion = "24.11";
}
