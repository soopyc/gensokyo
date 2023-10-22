{...}: {
  imports = [
    ./nginx.nix

    ./databases
    ./scm

    ./attic.nix

    # fediverse
    ./matrix
    ./fediverse

    ./security
    ./proxies
    ./static-sites
  ];
}
