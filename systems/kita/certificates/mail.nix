{...}: {
  security.acme.certs."mx-nbg.c.soopy.moe" = {
    extraLegoRenewFlags = [
      "--reuse-key"
    ];
    group = "nginx";
    extraDomainNames = [
      "mx2.soopy.moe"
      "dav.soopy.moe"
    ];
  };
}
