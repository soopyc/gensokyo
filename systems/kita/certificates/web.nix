{...}: {
  security.acme.certs."kita-web.c.soopy.moe" = {
    group = "nginx";
    extraDomainNames = [
      "kita.soopy.moe"
      "dav.soopy.moe"
      "webmail.soopy.moe"
    ];
  };
}
