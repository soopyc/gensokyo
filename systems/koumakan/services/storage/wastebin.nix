{
  _utils,
  config,
  ...
}:
let
  secrets = _utils.setupSecrets config {
    namespace = "wastebasket";
    secrets = [ "key" ];
  };
in
{
  # figure out a way to disable encryption, i don't trust the impl.
  imports = [
    secrets.generate
    (secrets.mkTemplate "wastebin.env" ''
      WASTEBIN_SIGNING_KEY=${secrets.placeholder "key"}
    '')
  ];
  gensokyo.ports.wastebin = 34682;
  services.wastebin = {
    enable = true;
    settings = {
      WASTEBIN_ADDRESS_PORT = "127.0.0.1:${toString config.gensokyo.ports.wastebin}";
      WASTEBIN_BASE_URL = "https://akyuu.soopy.moe";
      WASTEBIN_MAX_BODY_SIZE = 10240;
    };
    secretFile = secrets.getTemplate "wastebin.env";
  };

  services.nginx.virtualHosts."akyuu.soopy.moe" = _utils.mkSimpleProxy {
    port = config.gensokyo.ports.wastebin;
  };
}
