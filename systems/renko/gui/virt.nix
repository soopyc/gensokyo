{ lib, ... }:
{
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };

  # GPU Passthrough
  boot.initrd.kernelModules = [
    "vfio_pci" "vfio" "vfio_iommu_type1" "amdgpu"
  ];
  boot.kernelParams = lib.singleton ("vfio-pci.ids=" + lib.concatStringsSep "," [
    "1002:7480" # GPU video
    "1002:ab30" # GPU Audio
  ]);
  virtualisation.spiceUSBRedirection.enable = true;
}
