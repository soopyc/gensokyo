{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    # TODO: move this to a global trait config?
    ./gui

    inputs.nixos-hardware.nixosModules.apple-t2
  ];

  gensokyo.traits.gui = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.initrd.luks.fido2Support = true;
  boot.initrd.luks.devices."balls" = {
    fido2 = {
      credentials = [];
    };
  };

  # TODO: move this somewhere else
  services.yubikey-agent.enable = true;
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-qt;

  networking.hostName = "satori";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Hong_Kong";

  # muh unfree software!!!!!!!!!!!!!!!!!!
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.05"; # Did you read the comment? Yes.
}
