{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./gui
    ./development
    ./services
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd
  ];

  gensokyo = {
    traits = {
      gui = true;
      games = true;
    };
    presets = {
      vmetrics = true;
      secureboot = true;
    };
    system-manager = {
      enable = true;
      flakeLocation = "/home/cassie/gensokyo";
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "max";
  };
  boot.initrd.systemd.enable = true;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";

  fileSystems."/".options = [
    "compress=zstd:5"
    "autodefrag"
  ];

  networking.firewall = {
    allowedTCPPortRanges = [
      {
        from = 25560;
        to = 25570;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 25560;
        to = 25570;
      }
    ];
  };

  # muh unfree software!!!!!!!!!!!!!!!!!!
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.11"; # Did you read the comment? Yes.
}
