{...}: {
  imports = [
    ./global.nix
    ./postgresql.nix
    ./fediverse.nix
    ./bsky-pds.nix
  ];
}
