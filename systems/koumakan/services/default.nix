{ ... }:

{
  imports = [
    ./nginx.nix

    # databases
    ./redis.nix

    ./proxies
    ./static-sites
  ];
}
