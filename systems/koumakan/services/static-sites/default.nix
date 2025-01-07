{...}: {
  imports = [
    ./assets.nix
    ./nonbunary.nix
  ];

  # Fallback site
  services.nginx.virtualHosts."_" = {
    default = true;
    useACMEHost = "global.c.soopy.moe";
    forceSSL = true;

    locations = {
      "/".root = "/srv/www/fallback";
    };
  };
}
