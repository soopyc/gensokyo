{...}: {
  imports = [
    ./nginx.nix

    ./databases
    ./scm

    # "containers" in a burning text gif
    ./arion

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
