{...}: {
  imports = [
    ./certificates
    ./services
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap = {
    enable = true;
  };

  system.stateVersion = "23.11";
}
