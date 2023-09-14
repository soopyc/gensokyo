{...}: {
  imports = [
    ./nginx.nix

    # databases
    ./postgresql.nix
    ./redis.nix

    ./attic.nix

    # fediverse
    ./matrix
    ./fediverse

    ./proxies
    ./static-sites
  ];
}
