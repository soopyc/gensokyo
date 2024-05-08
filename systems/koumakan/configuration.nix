{inputs, ...}: {
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.attic.nixosModules.atticd
    inputs.mystia.nixosModules.fixups
    inputs.mystia.nixosModules.vmauth

    ./hardware-configuration.nix

    ./networking
    ./certificates
    ./security
    ./services

    ./administration
  ];

  gensokyo.traits.sensitive = true;

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    systemd-boot = {
      enable = true;
      graceful = true;
      netbootxyz.enable = true;
    };
    grub.enable = false;
  };

  # Just don't change this :p
  system.stateVersion = "23.05"; # Did you read the comment?
}
