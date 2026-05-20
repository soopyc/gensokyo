{
  imports = [
    ./osu.nix
    ./steam.nix
    ./minecraft.nix

    ./hud.nix
  ];

  # other random stuff
  programs.gamemode.enable = true;
}
