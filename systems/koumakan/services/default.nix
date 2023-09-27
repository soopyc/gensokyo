{...}: {
  imports = [
    ./nginx.nix

    ./databases

    ./attic.nix

    # fediverse
    ./matrix
    ./fediverse

    ./security
    ./proxies
    ./static-sites
  ];
}
