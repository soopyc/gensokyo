{
  _utils,
  config,
  ...
}:
let
  secrets = _utils.setupSecrets config {
    namespace = "minio";
    secrets = [
      "root_user"
      "root_pass"
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
    listenAddress = ":26531"; # will be proxied by koumakan
    rootCredentialsFile = secrets.getTemplate "minio.env";
  };

  # stupid module design
  systemd.services.minio.environment = {
    MINIO_BROWSER_REDIRECT_URL = "https://s3.soopy.moe/_static";
    MINIO_BROWSER_LOGIN_ANIMATION = "false";
  };
}
