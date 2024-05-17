{...}: {
  imports = [
    ./power.nix
    ./hardware.nix
    ./input.nix
    ./audio.nix

    ./wayland.nix
    ./kde.nix
    ./fonts.nix

    ./browser.nix
    ./security.nix
    ./development.nix

    ./degeneracy.nix
    ./packages.nix
  ];
}
