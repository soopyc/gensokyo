{
  _utils,
  config,
  ...
}:
let
  secrets = _utils.setupSecrets config {
    namespace = "pocket-id";
    secrets = [
      "encryption_key"
      "maxmind_key"
    ];
    config = {
      owner = config.users.users.pocket-id.name;
    };
  };
in
{
  imports = [ secrets.generate ];

  services.pocket-id = {
    enable = true;

    settings = {
      APP_URL = "https://gatekeeper.soopy.moe";
      HOST = "127.0.0.1";
      TRUST_PROXY = true;
      PORT = "31411";
      KEYS_STORAGE = "database";

      ENCRYPTION_KEY_FILE = secrets.get "encryption_key";
      MAXMIND_LICENSE_KEY_FILE = secrets.get "maxmind_key";
    };
  };

  services.nginx.virtualHosts."gatekeeper.soopy.moe" = _utils.mkSimpleProxy {
    port = 31411;

    extraConfig.locations."= /humans.txt" = _utils.mkNginxFile {
      filename = "humans.txt";
      content = ''
        /* Credits */
        Login Background: https://www.pixiv.net/artworks/122054405
        You: for using our services

        /* People */
        Administrator: soopyc
        Contact: https://soopy.moe/about

        /* Service */
        Software: Pocket ID
        Deployed-With: NixOS
        Security: https://soopy.moe/.well-known/security.txt
      '';
    };
  };
}
