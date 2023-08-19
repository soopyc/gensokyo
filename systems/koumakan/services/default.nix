{ ... }:

{
  imports = [
    ./nginx.nix

    # databases
    ./postgresql.nix
    ./redis.nix

    ./attic.nix

    ./proxies
    ./static-sites
  ];
}
