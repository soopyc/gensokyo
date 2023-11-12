# see /docs/utils.md for a usage guide
{
  inputs,
  system,
  ...
}: let
  pkgs = inputs.nixpkgs.legacyPackages.${system};
  lib = pkgs.lib;
in rec {
  mkVhost = opts:
    lib.mkMerge [
      {
        forceSSL = lib.mkDefault true;
        useACMEHost = lib.mkDefault "global.c.soopy.moe";
        kTLS = lib.mkDefault true;

        locations."/_cgi/error/" = {
          alias = "${inputs.mystia.packages.${system}.staticly}/nginx_error_pages/";
        };
        extraConfig = ''
          error_page 503 /_cgi/error/503.html;
          error_page 502 /_cgi/error/502.html;
          error_page 404 /_cgi/error/404.html;
        '';
      }
      opts
    ];

  mkSimpleProxy = {
    port,
    protocol ? "http",
    location ? "/",
    websockets ? false,
    extraConfig ? {},
  }:
    mkVhost (lib.mkMerge [
      extraConfig
      {
        locations."${location}" = {
          proxyPass = "${protocol}://localhost:${toString port}";
          proxyWebsockets = websockets;
        };
      }
    ]);

  genSecrets = namespace: files: value:
    lib.genAttrs (
      map (x: namespace + lib.optionalString (lib.stringLength namespace != 0) "/" + x) files
    ) (_: value);

  mkNginxFile = filename: contents:
    if (builtins.typeOf contents) != "string"
    then throw "argument $contents must be a string, got '${builtins.typeOf contents}' instead."
    else builtins.toString (pkgs.writeTextDir filename contents);

  mkNginxJSON = filename: attrset:
    if (builtins.typeOf attrset) != "set"
    then throw "argument"
    else mkNginxFile filename (builtins.toJSON attrset);
}
