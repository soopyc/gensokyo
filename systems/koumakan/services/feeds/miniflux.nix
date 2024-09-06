{_utils, config, ...}: let
  secrets = _utils.setupSecrets config {
    namespace = "miniflux";
    secrets = ["admin_pw"];
  };
in {
  imports = [
    secrets.generate
    (secrets.mkTemplate "miniflux.env" ''
      ADMIN_USERNAME=soopyc
      ADMIN_PASSWORD=${secrets.placeholder "admin_pw"}
    '')
  ];

  services.miniflux = {
    enable = true;
    config = {
      LISTEN_ADDR = "127.0.0.1:34723";
      BASE_URL = "https://flux.soopy.moe/";
      WEBAUTHN = 1;
    };

    adminCredentialsFile = secrets.getTemplate "miniflux.env";
  };

  services.nginx.virtualHosts."flux.soopy.moe" = _utils.mkSimpleProxy {
    port = 34723;
  };
}
