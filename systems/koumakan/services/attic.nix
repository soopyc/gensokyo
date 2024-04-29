{
  _utils,
  inputs,
  pkgs,
  ...
}: let
  # where tf are the docs for pkgs.formats??
  toml = pkgs.formats.toml {};
in {
  services.atticd = {
    enable = true;
    credentialsFile = "/etc/atticd.env";

    # I don't need more things to ruin my day
    package = inputs.attic.packages.${pkgs.system}.attic-nixpkgs;

    # Per https://github.com/zhaofengli/attic/blob/b43d12082e34bceb26038bdad0438fd68804cfcd/server/src/config.rs#L252
    # we can use the env var ATTIC_SERVER_DATABASE_URL to set the database connection url,
    # ONLY IF database.url in config is unset.
    # Since we cannot reasonably "unset" database with the default settings block, this will have to do.
    # Please reach out if you know a better way!
    configFile = toml.generate "server.toml" {
      database = {};
      storage = {
        type = "local";
        path = "/var/lib/atticd/storage";
      };

      listen = "127.0.0.1:38191";
      allowed-hosts = [
        "nonbunary.soopy.moe"
      ];
      chunking = {
        # The minimum NAR size to trigger chunking
        nar-size-threshold = 64 * 1024; # 64 KiB
        # The preferred minimum size of a chunk, in bytes
        min-size = 16 * 1024; # 16 KiB
        # The preferred average size of a chunk, in bytes
        avg-size = 64 * 1024; # 64 KiB
        # The preferred maximum size of a chunk, in bytes
        max-size = 256 * 1024; # 256 KiB
      };
    };
  };

  services.nginx.virtualHosts."nonbunary.soopy.moe" = _utils.mkSimpleProxy {
    port = 38191;
    extraConfig = {
      extraConfig = ''
        client_max_body_size 1G;
        proxy_read_timeout 3h;
        proxy_connect_timeout 3h;
        proxy_send_timeout 3h;
      '';
    };
  };
}
