{...}: {
  # Certificate for fedi services
  security.acme.certs."bsky.c.soopy.moe" = {
    group = "nginx";
    extraDomainNames = [
      "bsky.soopy.moe"
      "*.bsky.soopy.moe"
    ];
  };
}
