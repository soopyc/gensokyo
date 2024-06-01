{inputs, ...}: {
  imports = [
    ./certificates
    ./services
    ./arion

    inputs.hydra.nixosModules.hydra
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap = {
    enable = true;
  };

  gensokyo.presets.vmetrics = true;

  system.stateVersion = "23.11";
}
