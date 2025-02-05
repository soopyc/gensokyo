{...}: {
  imports = [
    ./dev
    ./path.nix
    ./obs.nix
    ./virt.nix
    ./eyecandy.nix
    ./ghostty.nix
    ./media.nix
    ./extras.nix
  ];

  home.stateVersion = "23.11";
}
