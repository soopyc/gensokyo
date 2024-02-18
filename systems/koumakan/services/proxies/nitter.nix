{
  _utils,
  pkgs,
  ...
}: {
  sops.secrets =
    _utils.genSecrets "nitter" [
      "guest_accounts_service/endpoint"
      "guest_accounts_service/token"
    ] {
      owner = "nitter";
    };

  services.nitterPatched = {
    enable = true;
    redisCreateLocally = false; # why is the default of this `true`??
    server = {
      title = "NSM";
      port = 36325;
      https = true;
      hostname = "nitter.soopy.moe";
      address = "127.0.0.1";
    };
    package = pkgs.nitterExperimental;
  };

  systemd.services.nitter = {
    serviceConfig.RuntimeMaxSec = "7d";
    environment = {
      NITTER_ACCOUNTS_FILE = "/var/lib/nitter/guest_accounts.jsonl";
    };
  };

  services.nginx.virtualHosts."nitter.soopy.moe" = _utils.mkSimpleProxy {
    port = 36325;
  };
}
