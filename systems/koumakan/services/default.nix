{...}: {
  imports = [
    ./nginx.nix

    ./databases
    ./scm
    ./ci

    # "containers" in a burning text gif
    ./arion

    # Gensokyo local stuff
    ./ftp.nix

    # fediverse
    ./matrix
    ./fediverse
    ./feeds

    ./anubis.nix
    ./telemetry
    ./security
    ./proxies
    ./static-sites
  ];
}
