{...}: {
  imports = [
    ./keine.nix
    ./photography.nix
    ./assets.nix
    ./nonbunary.nix
  ];

  # Fallback site
  services.nginx.virtualHosts."_" = {
    default = true;
    useACMEHost = "global.c.soopy.moe";
    forceSSL = true;
    # locations."/".return = "301 https://gensokyo.soopy.moe";

    # TODO: remove after bringing back up all the services.
    locations = {
      "/".return = "503";
      "~ ^/(index.html|splash.png)".root = "/srv/www/maintenance";
    };
    extraConfig = ''
      error_page 503 /index.html;
    '';
  };
}
