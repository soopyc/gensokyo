{...}: {
  imports = [
    ./atuin.nix
    ./postgresql.nix
    ./redis.nix
    ./wastebin.nix
  ];
}
