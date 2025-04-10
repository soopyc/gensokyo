# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e6637f8a-12fc-4aa4-8335-3fad10d8f63a";
    fsType = "btrfs";
  };

  fileSystems."/var/lib/minio/data" = {
    label = "MINIO0";
    fsType = "xfs";
  };

  boot.initrd.luks.devices."gock".device = "/dev/disk/by-uuid/9d57daa1-f152-443d-992c-b58cbfa57ec1";

  fileSystems."/efi" = {
    device = "/dev/disk/by-uuid/77E6-011C";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
      "umask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/40a77774-ab28-45db-8f8a-845814eacba9"; }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
