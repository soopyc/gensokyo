{
  _utils,
  inputs,
  ...
}: {
  services.nginx.virtualHosts = {
    "s3.soopy.moe" = _utils.mkSimpleProxy {
      host = "renko";
      port = 26531;
      extraConfig = {
        extraConfig = ''
          client_max_body_size 32G;
        '';

        locations."= /" = _utils.mkNginxFile {
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
              </ul>
            </body>
            </html>
          '';
        };
      };
    };

    "cache.soopy.moe" = _utils.mkVhost {
      locations."/".proxyPass = "http://renko:26531/nix-cache/";

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
