{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./steam.nix
    inputs.nixos-hardware.nixosModules.apple-t2
  ];

  gensokyo = {
    traits = {
      gui = true;
      games = true;
      portable = true;
    };
    presets = {
      vmetrics = true;
    };
    system-manager = {
      enable = true;
      flakeLocation = "/home/cassie/gensokyo";
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  boot.initrd.systemd.enable = true;

  hardware.firmware = [
    inputs.self.packages.${pkgs.system}.brcmfmac
  ];

  # muh unfree software!!!!!!!!!!!!!!!!!!
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.05"; # Did you read the comment? Yes.
}
