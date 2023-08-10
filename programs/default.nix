{ ... }: 
{
  imports = [
    ./nix.nix
    ./editors.nix
    ./shells.nix

    ./ssh.nix
    ./scm.nix

    ./misc.nix
  ];
}
