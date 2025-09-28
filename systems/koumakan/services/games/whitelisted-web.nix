{ _utils, config, ... }:
let
  secrets = _utils.setupSecrets config {
    namespace = "whitelisted-web";
    secrets = [
      "entra_secret"
      "turnstile_key"
      "ipc_token"
    ];
  };
in
{
  imports = [
    secrets.generate
    (secrets.mkTemplate "whitelisted-web.env" ''
      ENTRA_CLIENT_SECRET="${secrets.placeholder "entra_secret"}"
      TURNSTILE_SECRET_KEY="${secrets.placeholder "turnstile_key"}"
      SHARED_IPC_TOKEN="${secrets.placeholder "ipc_token"}"
    '')
  ];

  gensokyo.services.whitelisted-web = {
    enable = true;

    buildConfig = {
      PUBLIC_STATIC_CONTACT_INFO = ''{"Email": "mailto:Sophie Cheung <me@soopy.moe>"}'';
    };

    settings = {
      PORT = "30274";
      PUBLIC_URL = "https://renko.mist-nessie.ts.net:5173";
      PUBLIC_TOS_URI_TEMPLATE = "/tos/%LANG%.md";
      PUBLIC_SERVER_IP = "mc.soopy.moe"; # the public minecraft server IP
      PUBLIC_TURNSTILE_SITEID = "0x4AAAAAABifUhFToAkxeZDM";
      PUBLIC_ENTRA_CLIENT_ID = "807b9c9e-69c9-4b9f-b020-01dbf256623b";
    };

    environmentFile = secrets.getTemplate "whitelisted-web.env";
  };

  services.nginx.virtualHosts."mc.soopy.moe" = _utils.mkSimpleProxy {
    port = 30274;
  };
}
