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
      secrets.mkTemplate "rspamd-controller-pwd.conf" ''
        password = "${secrets.placeholder "controller_passwd"}";
      ''
    )
  ];
  services.rspamd = {
    enable = true;
    postfix.enable = true;
    locals.redis.text = ''
      servers = "${config.services.redis.servers.rspamd.unixSocket}";
    '';
    workers."controller".includes = [
      (secrets.getTemplate "rspamd-controller-pwd.conf")
    ];
  };

  services.redis.servers.rspamd = {};
  users.groups.redis-rspamd.members = [
    config.users.users.rspamd.name
  ];

  services.nginx.virtualHosts."kita.soopy.moe".locations."/rspamd" = {
    proxyPass = "http://localhost:11334"; # maybe expose this to tailnet instead
  };
}
