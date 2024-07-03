{...}: {
  imports = [
    ./nginx.nix

    ./databases
    ./scm

    # Gensokyo local stuff
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
