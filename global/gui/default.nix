{...}: {
  imports = [
    ./power.nix
    ./hardware.nix
    ./input.nix
    ./audio.nix

    ./wine.nix
    ./locale.nix

    ./dm.nix
    ./wayland.nix
    ./kde.nix
    ./fonts.nix

    ./browser.nix
    ./development.nix

    ./degeneracy.nix
    ./packages.nix
  ];
}
