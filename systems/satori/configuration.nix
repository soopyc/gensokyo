{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./steam.nix
    "${inputs.self}/modules/tiny-dfr"
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
  hardware.apple-t2.enableTinyDfr = false;
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
