{...}: {
  security.acme.certs."amia-sandbox.c.soopy.moe" = {
    group = "nginx";
    extraDomainNames = [
      "amia.sandbox.soopy.moe"
      "*.amia.sandbox.soopy.moe"
    ];
  };
}
