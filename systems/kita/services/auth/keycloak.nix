{
  _utils,
  config,
  ...
}: let
  secrets = _utils.setupSecrets config {
    namespace = "keycloak";
    secrets = ["db_password"];
  };
in {
  imports = [secrets.generate];
  services.keycloak = {
    enable = true;

    database.createLocally = true;
    database.passwordFile = secrets.get "db_password";
    settings = {
      hostname = "https://gateway.soopy.moe";
      hostname-admin = "http://127.0.0.1:34645";
      http-host = "127.0.0.1"; # access admin.gateway.soopy.moe via ssh forwarding
      http-port = 34645;
      https-port = 34646; # unused?

      # database automatically set up.
      # reverse proxy setup - identical to setting old proxy option to edge.
      http-enabled = true;
      proxy-headers = "xforwarded";
    };

    # TODO: make a custom theme for gensokyo.
    # themes = {};
  };

  services.nginx.virtualHosts."gateway.soopy.moe" = _utils.mkVhost {
    useACMEHost = "gateway.soopy.moe";
    locations = {
      "/".return = "301 https://kita.soopy.moe";
      "/admin".return = "444";
      "/metrics".return = "444";
      "/health".return = "444";

      "~ ^/(realms|resources|js)/" = {
        proxyPass = "http://localhost:34645";
        proxyWebsockets = true;
      };
    };
  };
}
