{ inputs, ... }:
{
  imports = [
    inputs.mystia.nixosModules.fixups
    inputs.mystia.nixosModules.vmauth
    inputs.mystia.nixosModules.bsky-pds
    inputs.mystia.nixosModules.mautrix-discord # technically not needed, but json will work better
    inputs.hydra.nixosModules.hydra
    inputs.whitelisted-web.nixosModules.default
    inputs.knotserver-module.nixosModules.default

    ./hardware-configuration.nix

    ./networking
    ./certificates
    ./security
    ./services

    ./administration
  ];

  gensokyo.traits = {
    sensitive = true;
  };
  gensokyo.presets.secureboot = true;
  gensokyo.presets.certificates = true;

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    systemd-boot = {
      enable = true;
      graceful = true;
      # netbootxyz.enable = true;
    };
    grub.enable = false;
  };

  # Just don't change this :p
  system.stateVersion = "23.05"; # Did you read the comment?
}
