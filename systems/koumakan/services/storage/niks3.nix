{ _utils, config, ... }:
let
  secrets = _utils.setupSecrets config {
    namespace = "niks3";
    secrets = [
      "api_token"
      "signing_keys/cache_soopy_moe_1"
      "s3/aid"
      "s3/sk"
    ];

    config.owner = config.services.niks3.user;
  };
in
{
  imports = [ secrets.generate ];

  services.niks3 = {
    enable = true;

    httpAddr = "127.0.0.1:31532";
    database.createLocally = true;

    cacheUrl = "https://cache.soopy.moe";
    serverUrl = "https://niks3.soopy.moe";

    s3 = {
      endpoint = "s3.soopy.moe";
      bucket = "nix-cache";
      region = "ap-east-1";

      accessKeyFile = secrets.get "s3/aid";
      secretKeyFile = secrets.get "s3/sk";
    };

    apiTokenFile = secrets.get "api_token";
    signKeyFiles = [
      (secrets.get "signing_keys/cache_soopy_moe_1")
    ];

    readProxy.enable = false; # for good measure
    nginx.enable = false; # we can do that ourselves... though mtls looks nice... impl after openbao

    gc = {
      enable = true;
      # other defaults look good
      schedule = "00:00 UTC";
    };
  };

  services.nginx.virtualHosts."niks3.soopy.moe" = _utils.mkSimpleProxy {
    port = 31532;
    extraConfig.extraConfig = ''
      proxy_connect_timeout 300s;
      proxy_read_timeout    300s;
      proxy_send_timeout    300s;
    '';
  };
}

