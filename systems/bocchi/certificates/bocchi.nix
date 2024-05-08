{...}: {
  security.acme.certs."bocchi.c.soopy.moe" = {
    group = "nginx";
    extraDomainNames = [
      "bocchi.soopy.moe"
      "hydra.soopy.moe"
    ];
  };
}
