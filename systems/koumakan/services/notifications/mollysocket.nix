{ _utils, config, ... }:
let
  secrets = _utils.setupSecrets config {
    namespace = "mollysocket";
    secrets = [ "vapid_key" ];
  };
in
{
  imports = [ secrets.generate ];

  gensokyo.ports.mollysocket = 35153;
  services.mollysocket = {
    enable = true;
    settings.port = config.gensokyo.ports.mollysocket;
    # we need vapid stuff else it won't start...
  };

  systemd.services.mollysocket.serviceConfig = {
    Environment = [
      "MOLLY_VAPID_KEY_FILE=%d/vapid_key"
    ];
    LoadCredential = [
      "vapid_key:${secrets.get "vapid_key"}"
    ];
  };

  services.nginx.virtualHosts."ms.soopy.moe" = _utils.mkSimpleProxy {
    port = config.gensokyo.ports.mollysocket;
  };
}
