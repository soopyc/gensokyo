{pkgs, ...}: {
  services.postgresql = {
    enable = true;

    package = pkgs.postgresql_15_pam;
    dataDir = "/var/lib/postgresql/15";
    logLinePrefix = "%m [%p] %h ";

    authentication = ''
      # unix socket connection
      local   all             all                                     pam
      # local ipv4/6 tcp connection
      host    all             all             127.0.0.1/32            scram-sha-256
      host    all             all             ::1/128                 scram-sha-256
      # world (encrypted) tcp traffic
      hostssl all             all             all                     scram-sha-256
    '';

    settings = let
      credsDir = "/run/credentials/postgresql.service";
    in {
      listen_addresses = pkgs.lib.mkForce "*";
      max_connections = 200;
      password_encryption = "scram-sha-256";

      ssl = "on";
      ssl_cert_file = "${credsDir}/cert.pem";
      ssl_key_file = "${credsDir}/key.pem";

      log_hostname = true;
      datestyle = "iso, dmy";
      log_timezone = "Asia/Hong_Kong";
      timezone = "Asia/Hong_Kong";
      default_text_search_config = "pc_catalog.english";

      max_wal_size = "2GB";
      min_wal_size = "80MB";
    };
  };
}
