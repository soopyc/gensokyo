{
  _utils,
  config,
  inputs,
  ...
}:
let
  secrets = _utils.setupSecrets config {
    namespace = "minio";
    secrets = [
      "root_user"
      "root_pass"
    ];
  };
in
{
  imports = [
    secrets.generate
    (secrets.mkTemplate "minio.env" ''
      MINIO_ROOT_USER=${secrets.placeholder "root_user"}
      MINIO_ROOT_PASSWORD=${secrets.placeholder "root_pass"}
    '')
  ];

  services.minio = {
    enable = true;
    region = "ap-east-1";
    listenAddress = "127.0.0.1:26531";
    rootCredentialsFile = secrets.getTemplate "minio.env";
  };

  # stupid module design
  systemd.services.minio.environment = {
    MINIO_BROWSER_REDIRECT_URL = "https://s3.soopy.moe/_static";
    MINIO_BROWSER_LOGIN_ANIMATION = "false";
  };

  services.nginx.virtualHosts = {
    "s3.soopy.moe" = _utils.mkSimpleProxy {
      port = 26531;
      extraConfig = {
        extraConfig = ''
          client_max_body_size 32G;
        '';

        locations."= /_static" = _utils.mkNginxFile {
          content = ''
            <!doctype html>
            <html lang="en">
            <head>
              <title>horrors of gensokyo</title>
              <style>
                :root {font-family: "monospace";}
              </style>
            </head>
            <body>
              <h1>gensokyo filedump - public buckets</h1>
              <ul>
                <li><a href="//cache.soopy.moe">nix-cache</a></li>
                <li>lwjgl-nix</li>
              </ul>
            </body>
            </html>
          '';
        };
      };
    };

    "cache.soopy.moe" = _utils.mkVhost {
      locations."/".proxyPass = "http://localhost:26531/nix-cache/";

      locations."= /" = {
        tryFiles = "/listing.html =500";
        root = inputs.mystia.packages.x86_64-linux.s3-listing.override {
          bucketName = "nix-cache";
          bucketUrl = "https://s3.soopy.moe/nix-cache/";
          bucketWebsiteUrl = "https://cache.soopy.moe";
        };
      };
    };
  };
}
