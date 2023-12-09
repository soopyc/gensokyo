{
  _utils,
  pkgs,
  config,
  ...
}: {
  sops.secrets = _utils.genSecrets "nitter" [
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
    path = [
      pkgs.xh
    ];
    serviceConfig.ExecStartPre = [
      (
        # because we already have a nitter system user, let's make this easier on ourselves
        pkgs.writeShellScript "nitter-prestart-tokens" ''
          set -euxo pipefail
          GUEST_ACCOUNTS_ENDPOINT=`cat ${config.sops.secrets."nitter/guest_accounts_service/endpoint".path}`
          xh "''${GUEST_ACCOUNTS_ENDPOINT}" key==@${config.sops.secrets."nitter/guest_accounts_service/token".path} host==${config.services.nitterPatched.server.hostname} \
            -o /var/lib/nitter/guest_accounts.jsonl -ph
          echo "Previous exit code: $?"
          sleep 5
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
