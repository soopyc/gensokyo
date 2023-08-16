{ ... }:

{
  imports = [
    ./nginx.nix

    # databases
    ./postgresql.nix
    ./redis.nix

    ./proxies
    ./static-sites
  ];
}
