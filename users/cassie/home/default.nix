{...}: {
  imports = [
    ./dev
    ./path.nix
    ./obs.nix
    ./virt.nix
    ./eyecandy.nix
    ./media.nix
    ./extras.nix
  ];

  home.stateVersion = "23.11";
}
