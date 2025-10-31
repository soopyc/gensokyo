{
  _utils,
  lib,
  config,
  ...
}:
let
  secrets = _utils.setupSecrets config {
    namespace = "minio";
    secrets = [
      "root_user"
      "root_pass"
      "vmetrics_token"
    ];
  };
in
{
  imports = [
    secrets.generate
    (secrets.mkTemplate "minio.env" ''
      MINIO_ROOT_USER=${secrets.placeholder "root_user"}
      MINIO_ROOT_PASSWORD=${secrets.placeholder "root_pass"}
    '')
  ];

  services.minio = {
    enable = true;
    region = "ap-east-1";
    listenAddress = "127.0.0.1:26531";
    rootCredentialsFile = secrets.getTemplate "minio.env";
  };

  # stupid module design
  systemd.services.minio.environment = {
    MINIO_BROWSER_REDIRECT_URL = "https://s3.soopy.moe/_static";
    MINIO_BROWSER_LOGIN_ANIMATION = "false";
  };

  systemd.services.vmagent.serviceConfig.LoadCredential = [
    "minio_token:${secrets.get "vmetrics_token"}"
  ];

  services.vmagent.prometheusConfig.scrape_configs = lib.singleton {
    job_name = "minio-job";
    metrics_path = "/minio/v2/metrics/cluster";
    scheme = "http";
    static_configs = lib.singleton { targets = lib.singleton "localhost:26531"; };
    relabel_configs = lib.singleton {
      target_label = "instance";
      replacement = config.networking.fqdnOrHostName;
    };

    # https://github.com/NixOS/nixpkgs/issues/367447
    # https://docs.victoriametrics.com/sd_configs/#scrape_configs
    # hard coding because we can't use %{ENV_VAR} syntax (yet) when checking.
    bearer_token_file = "/run/credentials/vmagent.service/minio_token";
  };
}
