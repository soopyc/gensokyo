{ ... }:
{
  imports = [
    ./dev
    ./path.nix
    ./obs.nix
    ./virt.nix
    ./eyecandy.nix
    ./shell.nix
    ./ghostty.nix
    ./media.nix
    ./syncthing.nix
    ./extras.nix
  ];

  home.stateVersion = "23.11";
}
