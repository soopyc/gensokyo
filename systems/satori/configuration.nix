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

  services.tiny-dfr = {
    enable = true;
    package = inputs.nixpkgs-master.legacyPackages.${pkgs.system}.tiny-dfr.overrideAttrs (_: _: {
      version = "0.3.0-unstable-2024-17-18";
      src = pkgs.fetchFromGitHub {
        name = "tiny-dfr-source";
        owner = "soopyc";
        repo = "tiny-dfr";
        rev = "1ffc883703f42ec6cc585d927bec2fc65a66e583";
        hash = "sha256-sVDSkBDfEOsTnLWPw0TQzOOQjPbU/hWzECNAqJ5TQtg=";
      };
    });
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
