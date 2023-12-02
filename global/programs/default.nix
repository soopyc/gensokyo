{...}: {
  imports = [
    ./nix.nix
    ./editors.nix
    ./shells.nix
    ./roaming-shell.nix
    ./multiplexers.nix

    ./compilers.nix

    ./ssh.nix
    ./scm.nix

    ./gpg.nix

    ./misc.nix
  ];
}
