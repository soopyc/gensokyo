{ ... }: 
{
  imports = [
    ./nix.nix
    ./editors.nix
    ./shells.nix

    ./compilers.nix

    ./ssh.nix
    ./scm.nix

    ./gpg.nix

    ./misc.nix
  ];
}
