# see /docs/utils.md for a usage guide

{ pkgs, ... }:

let
  lib = pkgs.lib;
in {
  mkVhost = opts: {
    # ideally mkOverride/mkDefault would be used, but i have 0 idea how it works.
    forceSSL = true;
    useACMEHost = "global.c.soopy.moe";
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
