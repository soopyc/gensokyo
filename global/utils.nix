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
        quic = lib.mkDefault true;

        locations."/_cgi/error/" = {
          alias = "${inputs.mystia.packages.${system}.staticly}/nginx_error_pages/";
        };

        # To override, mkForce {}
        locations."= /robots.txt" = mkNginxFile {
          status = 502;
          filename = "robots.txt";
          content = ''
            # Please stop hammering and/or scraping our services.
            User-Agent: *
            Disallow: /
          '';
        };

        extraConfig = ''
          access_log off;
          error_log /var/log/nginx/error.log crit;

          error_page 503 /_cgi/error/503.html;
          error_page 502 /_cgi/error/502.html;
          error_page 404 /_cgi/error/404.html;
          add_header strict-transport-security "max-age=63072000; includeSubDomains; preload";
          add_header alt-svc 'h3=":443";ma=86400';
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

  setupSecrets = _config: {
    namespace ? (lib.warn "secret namespace left as default, which is empty. it is encouraged to set a namespace for easier secret management. to override, explicitly set this to an empty value." ""),
    secrets,
    config ? {},
  }: let
    _r_ns = namespace + lib.optionalString (lib.stringLength namespace != 0) "/";
    check = path:
      if lib.elem path secrets
      then path
      else throw "secret path `${path}` is not defined in namespace `${namespace}`. (resolved: ${_r_ns namespace}/${path})";
    getRealPath = path: _r_ns + check path;
  in
    builtins.addErrorContext "while setting up secrets with namespace ${namespace}" {
      generate = {sops.secrets = genSecrets namespace secrets config;}; # i love trolling
      get = path: _config.sops.secrets.${getRealPath path}.path;

      placeholder = path: _config.sops.placeholder.${getRealPath path};
      getTemplate = file: _config.sops.templates.${file}.path;
      mkTemplate = file: content:
        builtins.addErrorContext "while generating sops template ${file}" {
          sops.templates.${file} =
            {inherit content;}
            // (lib.optionalAttrs (builtins.hasAttr "owner" config) {inherit (config) owner;})
            // (lib.optionalAttrs (builtins.hasAttr "group" config) {inherit (config) group;});
        };
    };

  genSecrets = namespace: files: value:
    lib.genAttrs (
      map (x: namespace + lib.optionalString (lib.stringLength namespace != 0) "/" + x) files
    ) (_: value);

  mkNginxFile = {
    filename ? "index.html",
    content,
    status ? 200,
  }: let
    contentDir =
      if (builtins.typeOf content) == "string"
      then builtins.toString (pkgs.writeTextDir filename content) + "/"
      else throw "parameter `content` must be a string, got `${builtins.typeOf content}` instead.";
  in {
    alias = contentDir;
    tryFiles = "${filename} =${builtins.toString status}";
  };

  mkNginxJSON = filename: attrset:
    if (builtins.typeOf attrset) != "set"
    then throw "attrset: expected argument type `set`, got `${builtins.typeOf attrset}` instead."
    else
      mkNginxFile {
        inherit filename;
        content = builtins.toJSON attrset;
      };
}
