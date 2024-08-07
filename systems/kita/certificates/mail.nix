{config, ...}: {
  security.acme.certs."kita.c.soopy.moe" = {
    group = config.services.maddy.group;
    extraLegoRenewFlags = [
      "--reuse-key"
    ];
    extraDomainNames = [
      "mx2.soopy.moe"
      "imap.soopy.moe"
      "smtp.soopy.moe"
    ];
  };
}
