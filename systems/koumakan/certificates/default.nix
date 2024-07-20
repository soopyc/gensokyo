{...}: {
  imports = [
    ./global.nix
    ./postgresql.nix
    ./fediverse.nix
    ./proxy.nix
  ];
}
