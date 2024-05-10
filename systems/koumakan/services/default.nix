{...}: {
  imports = [
    ./nginx.nix

    ./databases
    ./scm

    # Gensokyo local stuff
    ./attic.nix
    ./ftp.nix

    # fediverse
    ./matrix
    ./fediverse

    ./telemetry
    ./security
    ./proxies
    ./static-sites
  ];
}
