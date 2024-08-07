{config, ...}: {
  services.maddy = {
    enable = true;
    hostname = "mx2.soopy.moe";
    primaryDomain = "soopy.moe";
    localDomains = [
      "$(primary_domain)"
      "services.soopy.moe"
    ];

    tls = {
      loader = "file";
      certificates = [{
        certPath = config.security.acme.certs."kita.c.soopy.moe".directory + "/fullchain.pem";
        keyPath = config.security.acme.certs."kita.c.soopy.moe".directory + "/key.pem";
      }];
    };
  };
}
