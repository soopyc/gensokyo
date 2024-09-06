{...}: {
  security.acme.certs."gateway.soopy.moe" = {
    group = "nginx";
  };
}
