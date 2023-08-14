{ ... }:

{
  # Global certificate
  security.acme.certs."global.soopy.moe" = {
    group = "nginx";
    extraDomainNames = [
      "*.soopy.moe"
    ];
  };
}
