{inputs, ...}: {
  imports = [
    ./certificates
    ./services

    inputs.hydra.nixosModules.hydra
    inputs.mystia.nixosModules.bsky-pds
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap = {
    enable = true;
  };

  gensokyo.presets.vmetrics = true;

  system.stateVersion = "23.11";
}
