{ ... }:

{
  # Global certificate
  security.acme.certs."global.soopy.moe" = {
    extraDomainNames = [
      "*.soopy.moe"
    ];
  };
}
