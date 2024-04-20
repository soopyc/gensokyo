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

  gensokyo = {
    traits = {
      gui = true;
      games = true;
    };
    system-manager = {
      enable = true;
      flakeLocation = "/home/cassie/genso-nix";
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.initrd.luks.fido2Support = true;
  boot.initrd.luks.devices."balls" = {
    fido2 = {
      credentials = [
        "88aa01066717b958a2dfd1301cad434d38aa3b39f9623ebcec7a5f3720df97c23629f14dc7de2382f76e67faefb9eead"
      ];
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
