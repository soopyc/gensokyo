{...}: {
  # Certificate for fedi services
  security.acme.certs."fedi.c.soopy.moe" = {
    group = "nginx";
    extraDomainNames = [
      "a.soopy.moe"
      "m.soopy.moe"
      "words.soopy.moe"
      "pixie.soopy.moe"
    ];
  };
}
