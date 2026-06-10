{
  lib,
  ...
}:
{
  imports = [
    ./disk.nix
  ];

  sops.age.sshKeyPaths = lib.singleton "/persist/etc/ssh/ssh_host_ed25519_key";

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
