{ ... }:
{
  # Certificate for fedi services
  security.acme.certs."fedi.c.soopy.moe" = {
    group = "nginx";
    extraDomainNames = [
      "words.soopy.moe"
    ];
  };
}
