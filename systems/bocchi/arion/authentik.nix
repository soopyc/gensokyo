{
  _utils,
  config,
  ...
}: let
  secrets = _utils.setupSecrets config {
    namespace = "gateway";
    secrets = ["db_pass" "secret_key" "email_pass"];
  };
  fromDocker = image: "docker.io/library/${image}";

  commonEnv = rec {
    redisHost = "redis";
    dbHost = "postgresql";
    dbUser = "authentik";

    authentik = {
      AUTHENTIK_REDIS__HOST = redisHost;
      AUTHENTIK_POSTGRESQL__HOST = dbHost;
      AUTHENTIK_POSTGRESQL__USER = dbUser;
      AUTHENTIK_POSTGRESQL__NAME = dbUser;

      AUTHENTIK_EMAIL__HOST = "mail.soopy.moe";
      AUTHENTIK_EMAIL__PORT = 587;
      AUTHENTIK_EMAIL__USERNAME = "gateway@service.soopy.moe";
      AUTHENTIK_EMAIL__USE_TLS = "true"; # https://github.com/compose-spec/compose-spec/blob/55b450aee50799a2f33cc99e1d714518babe305e/05-services.md#environment
      AUTHENTIK_EMAIL__TIMEOUT = 10;
      AUTHENTIK_EMAIL__FROM = "gateway@service.soopy.moe";
    };

    ports = {
      http = 32841;
      metrics = 34218;
    };
  };
  versions = {
    authentik = "2024.4.2";
    postgres = "16-alpine";
  };
in {
  imports = [
    secrets.generate
    (secrets.mkTemplate "authentik.env" ''
      POSTGRES_PASSWORD=${secrets.placeholder "db_pass"}
      AUTHENTIK_POSTGRESQL__PASSWORD=${secrets.placeholder "db_pass"}

      AUTHENTIK_SECRET_KEY=${secrets.placeholder "secret_key"}
      AUTHENTIK_EMAIL__PASSWORD=${secrets.placeholder "email_pass"}
    '')
  ];

  virtualisation.arion.projects.authentik = _utils.mkArionProject (config': {
    services = {
      ${commonEnv.dbHost}.service = {
        image = fromDocker "postgres:${versions.postgres}";
        restart = "unless-stopped";
        healthcheck = {
          test = ["CMD-SHELL" "pg_isready -d $${POSTGRES_DB} -U $${POSTGRES_USER}"];
          start_period = "20s";
          interval = "30s";
          retries = 5;
          timeout = "5s";
        };
        environment = {
          POSTGRES_DB = commonEnv.dbUser;
          POSTGRES_USER = commonEnv.dbUser;
        };
        env_file = [(secrets.getTemplate "authentik.env")];

        volumes = ["/var/lib/authentik/db:/var/lib/postgresql/data"];
      };

      ${commonEnv.redisHost}.service = {
        image = fromDocker "redis:alpine";
        command = "--save 60 1 --loglevel warning";
        restart = "unless-stopped";
        healthcheck = {
          test = ["CMD-SHELL" "redis-cli ping | grep PONG"];
          start_period = "10s";
          interval = "30s";
          retries = 5;
          timeout = "2s";
        };
        volumes = ["/var/lib/authentik/redis:/data"];
      };

      ak_server.service = {
        image = "ghcr.io/goauthentik/server:${versions.authentik}";
        restart = "unless-stopped";
        command = "server";

        environment = commonEnv.authentik;
        env_file = [(secrets.getTemplate "authentik.env")];

        depends_on = [commonEnv.dbHost commonEnv.redisHost];

        volumes = ["/var/lib/authentik/media:/media"];
        ports = [
          "127.0.0.1:${toString commonEnv.ports.http}:9000"
          "127.0.0.1:${toString commonEnv.ports.metrics}:9300"
        ];
      };

      ak_worker.service = {
        image = "ghcr.io/goauthentik/server:${versions.authentik}";
        restart = "unless-stopped";
        command = "worker";
        user = "root"; # ok authentik

        environment = commonEnv.authentik;
        env_file = [(secrets.getTemplate "authentik.env")];

        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
          "/var/lib/authentik/media:/media"
          "/var/lib/authentik/certs:/certs"
        ];
        depends_on = [commonEnv.dbHost commonEnv.redisHost];
      };
    };
  });

  services.nginx.virtualHosts."gateway.soopy.moe" = _utils.mkSimpleProxy {
    port = commonEnv.ports.http;
    websockets = true;

    extraConfig = {
      useACMEHost = "gateway.soopy.moe";
    };
  };

  # TODO: refactor this to a utils function if it works.
  services.vmagent.prometheusConfig.scrape_configs = [
    {
      job_name = "authentik";
      static_configs = [{targets = ["localhost:${builtins.toString commonEnv.ports.metrics}"];}];
      relabel_configs = [
        {
          target_label = "instance";
          replacement = "${config.networking.fqdnOrHostName}";
        }
      ];
    }
  ];
}
