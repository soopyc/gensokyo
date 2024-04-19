{...}: {
  imports = [
    ./kde.nix
    ./browser.nix
    ./development.nix
    ./degeneracy.nix
    ./fonts.nix
    ./audio.nix
    ./power.nix
  ];

  environment.sessionVariables = {
    # wayland crap
    NIXOS_OZONE_WL = "1";
  };
}
