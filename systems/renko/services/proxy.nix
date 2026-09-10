{
  services.nginx = {
    enable = true;
    recommendedOptimisation = true;

    virtualHosts."renko.mist-nessie.ts.net" = {
      listen = [
        {
          addr = "100.100.32.32";
          port = 80;
        }
      ];

      locations."/" = {
        proxyPass = "http://110.40.153.242";
      };
    };
  };
}
