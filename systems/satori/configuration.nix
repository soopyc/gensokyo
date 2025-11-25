{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./steam.nix
    inputs.nixos-hardware.nixosModules.apple-t2
    inputs.nixos-hardware.nixosModules.common-cpu-intel
  ];

  gensokyo = {
    traits = {
      gui = true;
      games = true;
      portable = true;
      hidpi = true;
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

  # development
  # services.redis.servers."".enable = true;

  boot.initrd.systemd.enable = true;
  hardware.apple.touchBar = {
    enable = true;
    settings = {
      FontTemplate = "Hurmit Nerd Font";
    };
  };
  hardware.firmware = [
    inputs.self.packages.${pkgs.system}.brcmfmac
  ];

  hardware.apple-t2.kernelChannel = "stable";
  specialisation.latest-kernel.configuration.hardware.apple-t2.kernelChannel = lib.mkForce "latest";

  # experimental
  boot.kernelParams = [ "mem_sleep_default=s2idle" ];
  systemd = {
    services.tiny-dfr = {
      wantedBy = [
        "post-resume.target"
        "dev-tiny_dfr_display.device"
        "dev-tiny_dfr_backlight.device"
        "dev-tiny_dfr_display_backlight.device"
      ];
      after = [ "post-resume.target" ];
    };
  };

  environment.etc."systemd/timesyncd.conf.d/50-save-clock.conf".text = ''
    [Time]
    SaveIntervalSec=30
  '';

  environment.systemPackages = [
    pkgs.jetbrains.idea-ultimate
    pkgs.prismlauncher
  ];

  # TODO: make this a trait
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  users.groups.docker.members = [
    "cassie"
  ];

  zramSwap.enable = true;

  # muh unfree software!!!!!!!!!!!!!!!!!!
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.05"; # Did you read the comment? Yes.
}
