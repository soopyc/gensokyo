{...}: {
  imports = [
    ./kde.nix
    ./browser.nix
    ./fonts.nix
    ./audio.nix
    ./power.nix
    ./input.nix
    ./security.nix
    ./development.nix

    ./degeneracy.nix
    ./games
  ];

  environment.sessionVariables = {
    # wayland crap
    NIXOS_OZONE_WL = "1";
  };
}
