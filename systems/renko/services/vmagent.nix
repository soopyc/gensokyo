{
  _utils,
  config,
  lib,
  ...
}:
let
  secrets = _utils.setupSecrets config {
    namespace = "vmetrics";
    secrets = [ "minio_token" ];
  };
in
{
  imports = lib.singleton secrets.generate;
  systemd.services.vmagent.serviceConfig.LoadCredential = [
    "minio_token:${secrets.get "minio_token"}"
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
