{
  pkgs,
  lib,
  config,
  ...
}:
{
  gensokyo.ports.postgresql = 5432;
  services.postgresql = {
    enable = true;

    package = pkgs.postgresql_15;
    dataDir = "/var/lib/postgresql/15";

    authentication = lib.mkForce ''
      # unix socket connection
      local   all             all                                     peer
      # local ipv4/6 tcp connection
      host    all             all             127.0.0.1/32            scram-sha-256
      host    all             all             ::1/128                 scram-sha-256
    '';

    settings = {
      port = config.gensokyo.ports.postgresql;
      listen_addresses = pkgs.lib.mkForce "*";
      max_connections = 200;
      password_encryption = "scram-sha-256";

      log_line_prefix = "%m [%p] %h ";
      # ssl = "on";
      # ssl_cert_file = "${credsDir}/cert.pem";
      # ssl_key_file = "${credsDir}/key.pem";

      log_hostname = true;
      datestyle = "iso, dmy";
      log_timezone = "Asia/Hong_Kong";
      timezone = "Asia/Hong_Kong";
      default_text_search_config = "pg_catalog.english";

      max_wal_size = "2GB";
      min_wal_size = "80MB";
    };
  };

  # TODO: oneshot command for once-in-a-blue-moon db major version upgrades
  # niko oneshot:
  environment.systemPackages =
    let
      old = config.services.postgresql.finalPackage;
      new = pkgs.postgresql_18.withPackages config.services.postgresql.extensions;
    in
    lib.singleton (
      pkgs.writeScriptBin "postgres-upgrade-env" ''
        set -euo pipefail

        if test $UID -ne 0; then
          echo "You might want to run this as root. You should run this as root. Come on."
          exit 1
        fi

        PGBINOLD="${old}/bin"
        PGBINNEW="${new}/bin"

        PGDATAOLD="/var/lib/postgresql/${old.psqlSchema}"
        PGDATANEW="/var/lib/postgresql/${new.psqlSchema}"

        showdepend() {
          set -x
          systemctl show 'postgresql.*' --property Id,WantedBy,RequiredBy --no-pager
          set +x
        }

        enter() {
          set -x
          run0 -u postgres \
            --setenv PGBINOLD --setenv PGBINNEW \
            --setenv PGDATAOLD --setenv PGDATANEW \
            --setenv "pg_upgrade=${lib.getExe' new "pg_upgrade"}" \
            -D /var/lib/postgresql
          set +x
        }

        init() {
          set -x
          install -dm700 -o postgres -g postgres "$PGDATANEW"
          run0 -u postgres "${lib.getExe' new "initdb"}" -D "$PGDATANEW" ${lib.escapeShellArgs config.services.postgresql.initdbArgs}
          run0 -u postgres rm -v $PGDATANEW/postgresql.conf
          run0 -u postgres ln -sv "$(realpath $PGDATAOLD/postgresql.conf)" "$PGDATANEW/postgresql.conf"
          run0 -u postgres cp -v $PGDATAOLD/pg_hba.conf $PGDATANEW
          set +x
        }

        export PGBINOLD PGBINNEW PGDATAOLD PGDATANEW
        export -f enter init showdepend

        echo 'Postgresql is depended on by the following services:'
        showdepend
        echo
        echo 'It may be wise to turn them off first, then turn off postgresql.'
        echo
        echo "-------"
        echo 'Several environment variables have been set for use with pg_upgrade and other tooling:'
        echo '  PGBINOLD PGBINNEW PGDATAOLD PGDATANEW'
        echo
        echo 'Several functions have also been provided to aid in this step:'
        echo '  - enter()     : enter a shell as the `postgres` user with necessary variables set; pg_upgrade available as $pg_upgrade'
        echo '                  * remember to --clone on pg_upgrade'
        echo "  - init()      : initialize the directory $PGDATANEW with a new database"
        echo '  - showdepend(): show dependencies of postgresql.* as above.'
        echo
        echo 'See https://www.postgresql.org/docs/current/pgupgrade.html for documentation.'

        exec bash -u
      ''
    );

  users.users.postgres.useDefaultShell = lib.mkForce false;
}
