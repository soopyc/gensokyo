{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix

    # TODO: move this to a global trait config?
    ./gui

    inputs.nixos-hardware.nixosModules.apple-t2
  ];

  gensokyo = {
    traits = {
      gui = true;
      games = true;
      portable = true;
    };
    system-manager = {
      enable = true;
      flakeLocation = "/home/cassie/gensokyo";
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.initrd.systemd.enable = true;

  # TODO: move this to a trait
  nix.settings.trusted-users = [
    "@wheel"
  ];

  networking.hostName = "satori";

  # Set your time zone.
  time.timeZone = "Asia/Hong_Kong";

  # muh unfree software!!!!!!!!!!!!!!!!!!
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.05"; # Did you read the comment? Yes.
}
