{...}: {
  services.nginx = {
    enable = true;
    recommendedOptimisation = true;

    virtualHosts."renko.mist-nessie.ts.net" = {
      listen = [
        {
          addr = "100.86.12.107";
          port = 80;
        }
      ];

      locations."/" = {
        proxyPass = "http://110.40.153.242";
      };
    };
  };
}
