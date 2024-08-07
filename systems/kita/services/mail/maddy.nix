{...}: {
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
    };
  };
}
