{
  _utils,
  pkgs,
  ...
}: {
  services.nitter = {
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
    environment = {
      NITTER_ACCOUNTS_FILE = "/run/credentials/nitter.service/guest_accounts.json";
    };
    serviceConfig.LoadCredential = [
      "guest_accounts.json:/etc/nitter/guest_accounts.json"
    ];
  };

  services.nginx.virtualHosts."nitter.soopy.moe" = _utils.mkSimpleProxy {
    port = 36325;
  };
}
