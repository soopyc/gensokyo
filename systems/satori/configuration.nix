{
  inputs,
  pkgs,
  lib,
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

  # eduroam
  networking.wireless.iwd.enable = lib.mkForce false;
  networking.networkmanager.wifi.backend = lib.mkForce "wpa_supplicant";

  # development
  services.redis.servers."".enable = true;

  boot.initrd.systemd.enable = true;
  hardware.apple.touchBar = {
    enable = true;
    settings = {
      FontTemplate = "monospace";
    };
  };
  hardware.firmware = [
    inputs.self.packages.${pkgs.system}.brcmfmac
  ];

  zramSwap.enable = true;

  # muh unfree software!!!!!!!!!!!!!!!!!!
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.05"; # Did you read the comment? Yes.
}
