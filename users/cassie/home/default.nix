{ ... }:
{
  imports = [
    ./dev
    ./path.nix
    ./obs.nix
    ./virt.nix
    ./eyecandy.nix
    ./shell.nix
    ./media.nix
    ./syncthing.nix
    ./extras.nix

    ./hjem-glue.nix
  ];

  home.stateVersion = "23.11";
}
