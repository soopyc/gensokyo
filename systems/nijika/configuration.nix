{
  imports = [
    ./web
    ./disk.nix
    ./networking
  ];

  gensokyo.traits.ephemeral = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # experiment
  # nixpkgs.config.contentAddressedByDefault = true;

  system.stateVersion = "25.11";
}
