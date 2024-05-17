{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./kde.nix
    ./browser.nix
    ./fonts.nix
    ./audio.nix
    ./power.nix
    ./input.nix
    ./security.nix
    ./development.nix
    ./productivity.nix
    ./finance.nix
    ./media.nix

    ./devices.nix

    ./degeneracy.nix
  ];

  environment.sessionVariables = {
    # wayland crap
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";

    # FIXME: remove when 24.05 is released.
    LD_LIBRARY_PATH = lib.mkForce (lib.makeLibraryPath (with pkgs; [pipewire.jack pcsclite]));
  };
}
