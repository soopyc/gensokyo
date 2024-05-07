{...}: {
  # Certificate for fedi services
  security.acme.certs."proxy.c.soopy.moe" = {
    group = "nginx";
    extraDomainNames = [
      "sliding.proxy.production.matrix.soopy.moe"
      "sliding.proxy.staging.matrix.soopy.moe"
      "nixpkgs.reverse.proxy.internal.soopy.moe"
    ];
  };
}
