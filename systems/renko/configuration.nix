{inputs, ...}: {
  imports = [
    inputs.mystia.nixosModules.arrpc
    (inputs.self + "/modules/staging/yubikey-agent.nix")

    # TODO: move this to a global trait config?
    ./gui
  ];

  gensokyo = {
    traits = {
      gui = true;
      games = true;
    };
    presets = {
      vmetrics = false;
    };
    system-manager = {
      enable = true;
      flakeLocation = "/home/cassie/gensokyo";
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
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
