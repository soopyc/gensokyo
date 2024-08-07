{...}: {
  security.acme.certs."kita-web.c.soopy.moe" = {
    group = "nginx";
    extraDomainNames = [
      "kita.soopy.moe"
      "webmail.soopy.moe"
      "mta-sts.soopy.moe"
    ];
  };
}
