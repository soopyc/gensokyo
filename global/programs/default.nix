{ ... }: 
{
  imports = [
    ./nix.nix
    ./editors.nix
    ./shells.nix
    ./multiplexers.nix

    ./compilers.nix

    ./ssh.nix
    ./scm.nix

    ./gpg.nix

    ./misc.nix
  ];
}
