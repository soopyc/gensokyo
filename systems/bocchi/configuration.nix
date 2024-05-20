{...}: {
  imports = [
    ./certificates
    ./services
    ./arion
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap = {
    enable = true;
  };

  gensokyo.presets.vmetrics = true;

  system.stateVersion = "23.11";
}
