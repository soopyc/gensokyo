{
  imports = [
    ./assets.nix
    ./backup-public.nix
    ./nonbunary.nix
    ./user.nix
    ./verification.nix
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
