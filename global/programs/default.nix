{...}: {
  imports = [
    ./nix.nix
    ./editors.nix
    ./shells.nix
    ./roaming-shell.nix
    ./multiplexers.nix

    ./compilers.nix

    ./networking.nix
    ./ssh.nix
    ./scm.nix

    ./security

    ./system-manager
    ./misc.nix
  ];
}
