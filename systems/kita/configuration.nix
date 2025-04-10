{ ... }:
{
  imports = [
    ./certificates
    ./services

    ./networking.nix
  ];

  zramSwap.enable = true;
  gensokyo.presets = {
    nginx = true;
    vmetrics = true;
    certificates = true;
  };
  system.stateVersion = "24.05";
}
