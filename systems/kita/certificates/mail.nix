{...}: {
  security.acme.certs."kita.c.soopy.moe" = {
    extraLegoRenewFlags = [
      "--reuse-key"
    ];
    group = "nginx";
    extraDomainNames = [
      "mx2.soopy.moe"
    ];
  };
}
