# Copyright (c) 2023-2024 Cassie Cheung (soopyc)
# Permission is given to copy and use under the terms of Apache 2.0.
#
# you may copy-paste this entire file to anywhere else. just keep the comments.
# see /docs/src/utils/ for a usage guide
{
  inputs,
  system,
  ...
}:
let
  pkgs = inputs.nixpkgs.legacyPackages.${system};
  lib = pkgs.lib;
in
rec {
  mkVhost =
    opts:
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
          filename = "robots.txt";
          content = ''
            # Please stop hammering and/or scraping our services.
            User-Agent: *
            Disallow: /
          '';
        };

        extraConfig = ''
          error_page 503 /_cgi/error/503.html;
          error_page 502 /_cgi/error/502.html;
          error_page 404 /_cgi/error/404.html;
          add_header strict-transport-security "max-age=63072000; includeSubDomains; preload" always;
          add_header alt-svc 'h3=":443";ma=86400' always;
        '';
      }
      opts
    ];

  mkSimpleProxy =
    {
      protocol ? "http",
      host ? "localhost",
      port ? null,
      socketPath ? null,
      location ? "/",
      websockets ? false,
      extraConfig ? { },
    }:
    assert lib.assertMsg (
      port != null || socketPath != null
    ) "one of port or socketPath must be specified";
    # i dislike logic gates
    assert lib.assertMsg (
      !(port != null && socketPath != null)
    ) "only one of port or socketPath may be specified at the same time";
    assert lib.assertMsg (
      socketPath != null -> host == "localhost"
    ) "setting host has no effect when socketPath is set";
    assert lib.assertMsg (port != null -> builtins.isInt port) "port must be an integer if specified";
    mkVhost (
      lib.mkMerge [
        extraConfig
        {
          locations."${location}" = {
            proxyPass =
              "${protocol}://"
              + (if (socketPath == null) then "${host}:${builtins.toString port}" else "unix:${socketPath}");
            proxyWebsockets = websockets;
          };
        }
      ]
    );

  setupSecrets =
    _config:
    {
      namespace ? (
        lib.warn "secret namespace left as default, which is empty. it is encouraged to set a namespace for easier secret management. to override, explicitly set this to an empty value." ""
      ),
      secrets,
      config ? { },
    }:
    let
      _r_ns = namespace + lib.optionalString (lib.stringLength namespace != 0) "/";
      check =
        path:
        assert lib.assertMsg (lib.elem path secrets)
          "secret path `${path}` is not defined in namespace `${namespace}`. (resolved to: ${_r_ns namespace}/${path})";
        path;
      getRealPath = path: _r_ns + check path;
    in
    builtins.addErrorContext "while setting up secrets with namespace ${namespace}" {
      generate = {
        sops.secrets = genSecrets namespace secrets config;
      }; # i love trolling
      get = path: _config.sops.secrets.${getRealPath path}.path;

      placeholder = path: _config.sops.placeholder.${getRealPath path};
      getTemplate = file: _config.sops.templates.${file}.path;
      mkTemplate =
        file: content:
        builtins.addErrorContext "while generating sops template ${file}" {
          sops.templates.${file} = {
            inherit content;
          } // (builtins.removeAttrs config [ "content" ]);
          # // (lib.optionalAttrs (builtins.hasAttr "owner" config) {inherit (config) owner;})
          # // (lib.optionalAttrs (builtins.hasAttr "group" config) {inherit (config) group;});
        };
    };

  genSecrets =
    namespace: files: value:
    lib.genAttrs (map (
      x: namespace + lib.optionalString (lib.stringLength namespace != 0) "/" + x
    ) files) (_: value);

  mkNginxFile =
    {
      filename ? "index.html",
      content,
    }:
    builtins.addErrorContext "while creating a static nginx file ${filename}" (
      let
        contentDir =
          assert lib.assertMsg (
            builtins.typeOf content == "string"
          ) "content must be a string, got `${builtins.typeOf content}`";
          builtins.toString (pkgs.writeTextDir filename content) + "/";
      in
      {
        alias = contentDir;
        tryFiles = "${filename} =500"; # if it can't find the file something has gone wrong.
      }
    );

  mkNginxJSON =
    filename: attrset:
    builtins.addErrorContext "while creating a static nginx JSON file ${filename}" (
      assert lib.assertMsg (
        builtins.typeOf attrset == "set"
      ) "expected argument type `set`, got `${builtins.typeOf attrset}` instead.";
      mkNginxFile {
        inherit filename;
        content = builtins.toJSON attrset;
      }
    );
}
