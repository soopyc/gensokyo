{...}: {
  imports = [
    ./dev
    ./virt.nix
    ./eyecandy.nix
    ./extras.nix
  ];

  home.stateVersion = "23.11";
}
