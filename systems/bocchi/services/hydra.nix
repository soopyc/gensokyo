{_utils, config, ...}: let
  secrets = _utils.setupSecrets config {
    namespace = "hydra";
    secrets = ["signing_key"];
    config = {
      owner = config.users.users.hydra-www.name;
      group = config.users.users.hydra-www.group;
    };
  };
in {
  imports = [secrets.generate];

  services.hydra = {
    enable = true;
    listenHost = "127.0.0.1";
    useSubstitutes = true;
    hydraURL = "https://hydra.soopy.moe";
    notificationSender = "hydra@services.soopy.moe";
    smtpHost = "mail.soopy.moe";

    extraConfig = ''
      email_notification 1
      compress_build_logs 1
      binary_cache_secret_key_file ${secrets.get "signing_key"}
    '';

    # TODO: setup email
  };

  services.nginx.virtualHosts."hydra.soopy.moe" = _utils.mkSimpleProxy {
    port = 3000;
    extraConfig = {
      useACMEHost = "bocchi.c.soopy.moe";
    };
  };
}
