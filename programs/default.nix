{ ... }: 
{
  imports = [
    ./nix.nix
    ./editors.nix
    ./shells.nix

    ./ssh.nix
    ./scm.nix

    ./gpg.nix

    ./misc.nix
  ];
}
