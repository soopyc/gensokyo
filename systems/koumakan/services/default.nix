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
    ./feeds

    ./telemetry
    ./security
    ./proxies
    ./static-sites
  ];
}
