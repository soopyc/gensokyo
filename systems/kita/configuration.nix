{...}: {
  imports = [
    ./networking.nix
    ./hardware-configuration.nix
  ];

  gensokyo.presets.vmetrics = true;
  system.stateVersion = "23.11";
}
