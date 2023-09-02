# see /docs/utils.md for a usage guide

{ ... }:

# let
  # lib = pkgs.lib;
# in
rec {
  mkVhost = opts: {
    # ideally mkOverride/mkDefault would be used, but i have 0 idea how it works.
    forceSSL = true;
    useACMEHost = "global.c.soopy.moe";
    kTLS = true;
  } // opts;

  mkSimpleProxy = {
    port,
    protocol ? "http",
    location ? "/",
    websockets ? false
  }: mkVhost {
    locations."${location}" = {
      proxyPass = "${protocol}://localhost:${toString port}";
      proxyWebsockets = websockets;
    };
  };
}
