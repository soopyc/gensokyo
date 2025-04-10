{ _utils, ... }:
{
  services.miniflux = {
    enable = true;
    config = {
      LISTEN_ADDR = "127.0.0.1:34723";
      BASE_URL = "https://flux.soopy.moe/";
      WEBAUTHN = 1;
      CREATE_ADMIN = 0;
    };
  };

  services.nginx.virtualHosts."flux.soopy.moe" = _utils.mkSimpleProxy {
    port = 34723;
  };
}
