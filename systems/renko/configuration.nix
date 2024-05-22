{pkgs, ...}: {
  imports = [
    ./gui
    ./docker.nix
  ];

  gensokyo = {
    traits = {
      gui = true;
      games = true;
      secure = true;
    };
    presets = {
      vmetrics = true;
    };
    system-manager = {
      enable = true;
      flakeLocation = "/home/cassie/gensokyo";
    };
  };

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_6_9;

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

  # muh unfree software!!!!!!!!!!!!!!!!!!
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.11"; # Did you read the comment? Yes.
}
