{ ... }:
{
  imports = [
    ./nix

    ./editors.nix
    ./shells.nix
    ./multiplexers.nix

    ./compat.nix

    ./networking.nix
    ./ssh.nix
    ./scm.nix

    ./security

    ./system-manager
    ./misc.nix
  ];
}
