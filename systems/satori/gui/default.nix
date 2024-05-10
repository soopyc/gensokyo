{...}: {
  imports = [
    ./kde.nix
    ./browser.nix
    ./fonts.nix
    ./audio.nix
    ./power.nix
    ./input.nix
    ./security.nix
    ./virt.nix
    ./development.nix

    ./devices.nix

    ./degeneracy.nix
    ./games
  ];

  environment.sessionVariables = {
    # wayland crap
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };
}
