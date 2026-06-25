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

  # my patience has limits and it's all gone, home-manager
  # disappear from my eyesight at the earliest convenience
  fonts.fontconfig.enable = false;

  home.stateVersion = "23.11";
}
