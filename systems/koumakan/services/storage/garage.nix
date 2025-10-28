{
  _utils,
  config,
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
  };
in
{
  imports = [ secrets.generate ];
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

      rpc_bind_addr = "100.100.16.16:39931";
      rpc_public_addr = "koumakan.mist-nessie.ts.net:39931";
      rpc_secret_file = secrets.get "rpc_secret";

      s3_api = {
        s3_region = "ap-east-1";
        api_bind_addr = "[::1]:39930";
        root_domain = ".s3.soopy.moe";
      };

      admin = {
        api_bind_addr = "100.100.16.16:39932";
        admin_token_file = secrets.get "admin_token";
        metrics_token_file = secrets.get "metrics_token";
      };
    };
  };
}
