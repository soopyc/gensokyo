{...}: {
  imports = [
    ./kde.nix
    ./browser.nix
    ./development.nix
    ./fonts.nix
    ./audio.nix
    ./power.nix

    ./degeneracy.nix
    ./games
  ];

  environment.sessionVariables = {
    # wayland crap
    NIXOS_OZONE_WL = "1";
  };
}
