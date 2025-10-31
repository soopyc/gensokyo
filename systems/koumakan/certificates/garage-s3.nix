{
  # Certificate for garage domains
  security.acme.certs."s3.soopy.moe" = {
    group = "nginx";
    extraDomainNames = [
      "*.s3.soopy.moe"
      "*.s3web.soopy.moe"
    ];
  };
}
