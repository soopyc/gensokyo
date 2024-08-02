{
  config,
  _utils,
  ...
}: let
  secrets = _utils.setupSecrets config {
    namespace = "rspamd";
    secrets = ["controller_passwd"];
    config.owner = config.users.users.rspamd.name;
  };
in {
  imports = [
    secrets.generate
    (
      secrets.mkTemplate "rspamd-controller-pwd.inc" ''
        password = "${secrets.placeholder "controller_passwd"}";
      ''
    )
  ];
  services.rspamd = {
    enable = true;
    postfix.enable = true;
    locals = {
      "redis.conf".text = ''
        servers = "${config.services.redis.servers.rspamd.unixSocket}";
      '';

      "milter_headers.conf".text = ''
        use = ["x-spamd-result", "x-spamd-bar", "authentication-results", "x-spam-status"];
      '';

      "dkim_signing.conf".text = ''
        domain {
          soopy.moe {
            selectors = [
              {selector: "2029-rsa"},
              {selector: "2029-ed"}
            ]
          }

          services.soopy.moe {
            selectors = [
              {selector: "2029-rsa"},
              {selector: "2029-ed"}
            ]
          }
        }
      '';

      # global options, which is different from sections
      "options.inc".text = ''
        dns {
          nameserver = "127.0.0.1:53";
        }
      '';
    };
    workers."controller".extraConfig = ''
      .include(try=false; priority=10) "${secrets.getTemplate "rspamd-controller-pwd.inc"}"
    '';
  };

  services.redis.servers.rspamd.enable = true;
  users.groups.redis-rspamd.members = [
    config.users.users.rspamd.name
  ];

  services.nginx.virtualHosts."_".locations."/rspamd" = {
    proxyPass = "http://localhost:11334"; # maybe expose this to tailnet instead
    extraConfig = "rewrite /rspamd/(.*) /$1 break;";
  };
}
