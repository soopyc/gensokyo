{_utils, ...}: {
  services.nginx.virtualHosts."users.soopy.moe" = _utils.mkVhost {
    locations."/" = _utils.mkNginxFile {
      content = ''
        <!doctype html>
        <html lang="en">
        <head>
          <meta charset="utf-8" />
          <meta name="viewport" content="width=device-width, initial-scale=1.0" />
          <style>:root {font-family: monospace;}</style>
          <title>~</title>
        </head>

        <body>
          <h1>You are at ~</h1>
          <ul>
            <li><a href="/~soopyc" title="web hosting for soopyc">~soopyc</a></li>
          </ul>
        </body>
        </html>
      '';
    };

    locations."/~soopyc" = {
      root = "/home/cassie/Web";
      tryFiles = "$uri $uri/index.html $uri.html =404";
      extraConfig = "autoindex on;";
    };
  };
}
