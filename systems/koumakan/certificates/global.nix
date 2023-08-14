{ ... }:

{
  # Global certificate
  security.acme.certs."global.c.soopy.moe" = {
    group = "nginx";
    extraDomainNames = [
      "*.soopy.moe"
    ];
  };
}
