{...}: {
  imports = [
    ./nginx.nix

    # databases
    ./postgresql.nix
    ./redis.nix

    ./attic.nix

    # fediverse
    ./matrix

    ./proxies
    ./static-sites
  ];
}
