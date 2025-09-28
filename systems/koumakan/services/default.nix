{ ... }:
{
  imports = [
    ./nginx.nix
    ./anubis.nix

    # "containers" in a burning text gif
    ./arion

    # Gensokyo local stuff
    ./ftp.nix

    # fediverse
    ./matrix
    ./fediverse
    ./feeds

    ./ci
    ./databases
    ./games
    ./mirror
    ./proxies
    ./scm
    ./security
    ./static-sites
    ./storage
    ./telemetry
  ];
}
