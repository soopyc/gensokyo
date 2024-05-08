{...}: {
  imports = [
    ./certificates
    ./services
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap = {
    enable = true;
  };

  gensokyo.presets.vmetrics = true;

  system.stateVersion = "23.11";
}
