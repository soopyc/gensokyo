{ _utils, config, ... }:
let
  secrets = _utils.setupSecrets config {
    namespace = "mollysocket";
    secrets = [ "vapid_key" ];
  };
in
{
  imports = [ secrets.generate ];
  services.mollysocket = {
    enable = true;
    settings.port = 35153;
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
    port = 35153;
  };
}
