{
  modulesPath,
  lib,
  ...
}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "xen_blkfront" "vmw_pvscsi"];
  boot.initrd.kernelModules = ["nvme"];
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/14EF-4002";
    fsType = "vfat";
  };
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/88cb39be-b19e-4c4a-b544-286b2f45f003";
    fsType = "xfs";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
