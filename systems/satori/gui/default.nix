{...}: {
  imports = [
    ./power.nix
    ./hardware.nix
    ./audio.nix
    ./media.nix

    ./wayland.nix
    ./kde.nix
    ./fonts.nix

    ./browser.nix
    ./input.nix
    ./security.nix
    ./development.nix

    ./degeneracy.nix
  ];
}
