{
  _utils,
  lib,
  config,
  ...
}:
let
  secrets = _utils.setupSecrets config {
    namespace = "zipline";
    secrets = [
      "core/secret"
      "s3/access_key"
      "s3/access_secret"
    ];
  };
in
{
  imports = [
    secrets.generate
    (secrets.mkTemplate "zipline.env" ''
      CORE_SECRET=${secrets.placeholder "core/secret"}
      DATASOURCE_S3_ACCESS_KEY_ID=${secrets.placeholder "s3/access_key"}
      DATASOURCE_S3_SECRET_ACCESS_KEY=${secrets.placeholder "s3/access_secret"}
    '')
  ];

  services.zipline = {
    enable = true;
    environmentFiles = lib.singleton (secrets.getTemplate "zipline.env");

    settings = {
      CORE_PORT = 34638;
      DATASOURCE_TYPE = "s3";
      DATASOURCE_S3_BUCKET = "zipline-01";
      DATASOURCE_S3_REGION = "ap-east-1";
      DATASOURCE_S3_ENDPOINT = "https://s3.soopy.moe";
      DATASOURCE_S3_FORCE_PATH_STYLE = "true";
    };
  };

  services.nginx.virtualHosts."dumpster.soopy.moe" = _utils.mkSimpleProxy {
    port = 34638;
    extraConfig.extraConfig = ''
      client_max_body_size 100M;
    '';
  };
}
