{ pkgs, lib, ... }:
{
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };

  virtualisation.waydroid.enable = true;

  # try virtualbox
  virtualisation.virtualbox.host = {
    # nah cba. doesn't do what we need it to do well.
    enable = false;
    # enableKvm = true;
    # enableExtensionPack = false;
    # addNetworkInterface = false; # conflicts with KVM
  };

  environment.systemPackages = lib.singleton pkgs.winboat;
  users.users.cassie.extraGroups = [ "libvirtd" ];

  # security.polkit.extraConfig = ''
  #   // allow unconditional access to libvirt for cassie
  #   polkit.addRule(function (action, subject) {
  #     if (action.id == "org.libvirt.unix.manage" && subject.local && subject.active && subject.user == "cassie")
  #       return polkit.Result.YES;
  #   });
  # '';

  # GPU Passthrough
  # boot.initrd.kernelModules = [
  #   "vfio_pci" "vfio" "vfio_iommu_type1" "amdgpu"
  # ];
  # boot.kernelParams = lib.singleton ("vfio-pci.ids=" + lib.concatStringsSep "," [
  #   "1002:7480" # GPU video
  #   "1002:ab30" # GPU Audio
  # ]);
  # virtualisation.spiceUSBRedirection.enable = true;

  # vm performance is still terrible after pinning
}
