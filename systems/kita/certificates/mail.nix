{...}: {
  security.acme.certs."kita.c.soopy.moe" = {
    extraLegoRenewFlags = [
      "--reuse-key"
    ];
    extraDomainNames = [
      "mx2.soopy.moe"
    ];
  };
}
