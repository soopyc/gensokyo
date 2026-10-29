{
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.mystia.nixosModules.stalwart-minimal
    ./disk.nix

    ./services
    ./networking
  ];

  gensokyo.traits.ephemeral = true;

  # try something new
  boot.loader.limine = {
    enable = true;
    maxGenerations = 3;

    biosSupport = true;
    biosDevice = "/dev/sda";
    partitionIndex = 1;

    efiSupport = true;
    efiInstallAsRemovable = true;

    extraConfig = ''
      graphics: no
    '';
  };

  system.stateVersion = "26.05";
}
