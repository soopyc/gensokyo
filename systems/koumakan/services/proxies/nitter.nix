{
  _utils,
  pkgs,
  config,
  ...
}: {
  sops.secrets = _utils.genSecrets "nitter" [
    "guest_accounts_service/endpoint"
    "guest_accounts_service/token"
  ] {};

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
    serviceConfig.ExecStartPre = [
      (
        pkgs.writeShellScript "nitter-prestart-tokens" ''
          GUEST_ACCOUNTS_ENDPOINT=`cat ${config.sops.secrets."nitter/guest_accounts_service/endpoint".path}`
          GUEST_ACCOUNTS_TOKEN=`cat ${config.sops.secrets."nitter/guest_accounts_service/token".path}`
          xh "''${GUEST_ACCOUNTS_ENDPOINT}" key==''${GUEST_ACCOUNTS_TOKEN} host==${config.services.nitterPatched.server.hostname} \
            -o /var/lib/nitter/guest_accounts.jsonl
          unset GUEST_ACCOUNTS_{ENDPOINT,TOKEN}
        ''
      )
    ];
    environment = {
      NITTER_ACCOUNTS_FILE = "/var/lib/nitter/guest_accounts.jsonl";
    };
  };

  services.nginx.virtualHosts."nitter.soopy.moe" = _utils.mkSimpleProxy {
    port = 36325;
  };
}
