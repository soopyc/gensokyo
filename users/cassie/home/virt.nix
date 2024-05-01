{...}: {
  # this complements **/*/virt.nix in nixos modules.
  dconf.settings."org/virt-manager/virt-manager/connections" = {
    autoconnect = ["qemu:///system"];
    uris = ["qemu:///system"];
  };
}
