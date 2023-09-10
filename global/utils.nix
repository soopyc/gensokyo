# see /docs/utils.md for a usage guide
{
  inputs,
  system,
  ...
}: rec {
  mkVhost = {extraConfig ? "", ...} @ opts:
    {
      # ideally mkOverride/mkDefault would be used, but i have 0 idea how it works.
      forceSSL = true;
      useACMEHost = "global.c.soopy.moe";
      kTLS = true;
    }
    // opts
    // {
      # we do some funny things here
      locations =
        opts.locations
        // {
          "/_cgi/error/" = {alias = "${inputs.mystia.packages.${system}.staticly}/nginx_error_pages/";};
        };
      extraConfig =
        ''
          error_page 503 /_cgi/error/503.html;
          error_page 502 /_cgi/error/502.html;
          error_page 404 /_cgi/error/404.html;
        ''
        + extraConfig;
    };

  mkSimpleProxy = {
    port,
    protocol ? "http",
    location ? "/",
    websockets ? false,
  }:
    mkVhost {
      locations."${location}" = {
        proxyPass = "${protocol}://localhost:${toString port}";
        proxyWebsockets = websockets;
      };
    };
}
