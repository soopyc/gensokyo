{...}: {
  imports = [
    ./dev
    ./obs.nix
    ./virt.nix
    ./eyecandy.nix
    ./extras.nix
  ];

  home.stateVersion = "23.11";
}
