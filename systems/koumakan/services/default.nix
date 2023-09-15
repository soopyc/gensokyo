{...}: {
  imports = [
    ./nginx.nix

    ./databases

    ./attic.nix

    # fediverse
    ./matrix
    ./fediverse

    ./proxies
    ./static-sites
  ];
}
