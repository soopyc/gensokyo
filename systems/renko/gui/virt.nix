{ ... }:
{
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };
}
