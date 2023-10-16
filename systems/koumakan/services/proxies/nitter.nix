{
  _utils,
  pkgs,
  sopsDir,
  ...
}: {
  sops.secrets."nitter.guest_accounts.jsonl" = {
    sopsFile = sopsDir + "/guest_accounts.jsonl";
    format = "binary";
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
    environment = {
      NITTER_ACCOUNTS_FILE = "/tmp/guest_accounts.jsonl";
    };

    serviceConfig = {
      User = "nitter";
      ExecStartPre = [
        "!/usr/bin/install --owner=nitter -m600 --no-target-directory /run/secrets/nitter.guest_accounts.jsonl /tmp/guest_accounts.jsonl"
      ];
    };
  };

  services.nginx.virtualHosts."nitter.soopy.moe" = _utils.mkSimpleProxy {
    port = 36325;
  };
}
