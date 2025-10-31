{
  _utils,
  config,
  lib,
  pkgs,
  ...
}:
let
  secrets = _utils.setupSecrets config {
    namespace = "garage";
    secrets = [
      "rpc_secret"
      "admin_token"
      "metrics_token"
    ];
    config.owner = "garage";
  };
in
{
  imports = [ secrets.generate ];

  users = {
    users.garage = {
      isSystemUser = true;
      group = "garage";
    };
    groups.garage = {};
  };

  services.garage = {
    enable = true;
    package = pkgs.garage_2;

    settings = {
      metadata_dir = "/var/lib/garage/meta";
      metadata_snapshots_dir = "/var/lib/garage/snapshots";
      data_dir = "/var/lib/garage/data";
      db_engine = "sqlite";
      metadata_auto_snapshot_interval = "6h";

      replication_factor = 1; # we only have the resources for a single node atm.
      compression_level = 4;

      s3_api = {
        s3_region = "ap-east-1";
        api_bind_addr = "[::1]:39930";
        root_domain = ".s3.soopy.moe";
      };

      rpc_bind_addr = "100.100.16.16:39931";
      rpc_public_addr = "koumakan.mist-nessie.ts.net:39931";
      rpc_secret_file = secrets.get "rpc_secret";

      admin = {
        api_bind_addr = "100.100.16.16:39932";
        admin_token_file = secrets.get "admin_token";
        metrics_token_file = secrets.get "metrics_token";
      };
    };
  };

  systemd.tmpfiles.settings."50-garage-init"."/var/lib/garage"."d" = {
    user = "garage";
    group = "garage";
    mode = "0700";
  };

  systemd.services.garage.serviceConfig = {
    DynamicUser = false; # we need to use a mounted filesystem and systemd explodes when i already have a mountpoint at /var/lib/garage/data.
    User = config.users.users.garage.name;
    Group = config.users.groups.garage.name;
    Restart = "on-failure";
    StateDirectory = lib.mkForce null; # this somehow breaks mounting dirs into /var/lib; systemd complains about id-mapped mount: device or resource busy
    # ReadWritePaths = [
    #   "/var/lib/garage"
    #   "/var/lib/garage/data"
    #   "/var/lib/garage/meta"
    #   "/var/lib/garage/snapshots"
    # ];
  };

  services.nginx.virtualHosts.".s3.soopy.moe" = _utils.mkSimpleProxy {
    port = 39930;
    extraConfig = {
      extraConfig = ''
        client_max_body_size 32G;
        proxy_max_temp_file_size 0;
      '';

      locations."= /_static" = _utils.mkNginxFile {
        content = ''
          <!doctype html>
          <html lang="en">
          <head>
            <title>horrors of gensokyo</title>
            <style>
              :root {font-family: "monospace";}
            </style>
          </head>
          <body>
            <h1>gensokyo filedump - public buckets</h1>
            <ul>
              <li><a href="//cache.soopy.moe">nix-cache</a></li>
              <li>lwjgl-nix</li>
            </ul>
          </body>
          </html>
        '';
      };
    };
  };

  systemd.services.vmagent.serviceConfig.LoadCredential = [
    "garage_token:${secrets.get "metrics_token"}"
  ];

  services.vmagent.prometheusConfig.scrape_configs = lib.singleton {
    job_name = "garage-job";
    scheme = "http";
    static_configs = lib.singleton { targets = lib.singleton "localhost:39932"; };
    relabel_configs = lib.singleton {
      target_label = "instance";
      replacement = config.networking.fqdnOrHostName;
    };

    # https://github.com/NixOS/nixpkgs/issues/367447
    # https://docs.victoriametrics.com/sd_configs/#scrape_configs
    # hard coding because we can't use %{ENV_VAR} syntax (yet) when checking.
    bearer_token_file = "/run/credentials/vmagent.service/garage_token";
  };
}
