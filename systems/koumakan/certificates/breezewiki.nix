{ ... }:
{
  # Certificate for breezewiki
  security.acme.certs."bw.c.soopy.moe" = {
    group = "nginx";
    extraDomainNames = [
      "bw.soopy.moe"
      "*.bw.soopy.moe"
    ];
  };
}
