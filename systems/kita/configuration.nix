{...}: {
  imports = [
    ./networking.nix
  ];

  zramSwap.enable = true;
  system.stateVersion = "24.05";
}
