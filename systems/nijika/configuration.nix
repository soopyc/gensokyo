{
  lib,
  ...
}:
{
  imports = [
    ./web
    ./disk.nix
    ./networking
  ];

  sops.age.sshKeyPaths = lib.singleton "/persist/etc/ssh/ssh_host_ed25519_key";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";

  # experiment
  # nixpkgs.config.contentAddressedByDefault = true;

  system.stateVersion = "25.11";
}
