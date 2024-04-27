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

    ./gpg.nix
    ./smartcard.nix

    ./system-manager
    ./misc.nix
  ];
}
