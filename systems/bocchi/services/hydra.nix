{_utils, config, ...}: let
  secrets = _utils.setupSecrets config {
    namespace = "hydra";
    secrets = [
      "signing_key"
      "mail/password"
      "auth/gitea/cassie"
    ];
    config = {
      owner = config.users.users.hydra-www.name;
      group = config.users.users.hydra-www.group;
      mode = "0440";
    };
  };
in {
  imports = [
    secrets.generate

    (secrets.mkTemplate "hydra-auth.conf" ''
      <gitea_authorization>
        cassie = ${secrets.placeholder "auth/gitea/cassie"}
      </gitea_authorization>
    '')

    (secrets.mkTemplate "hydra-email.env" ''
      EMAIL_SENDER_TRANSPORT=SMTP
      EMAIL_SENDER_TRANSPORT_host=mail.soopy.moe
      EMAIL_SENDER_TRANSPORT_ssl=starttls
      EMAIL_SENDER_TRANSPORT_helo=hydra.soopy.moe
      EMAIL_SENDER_TRANSPORT_sasl_username=hydra@services.soopy.moe
      EMAIL_SENDER_TRANSPORT_sasl_password=${secrets.placeholder "mail/password"}
    '')
  ];

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

      # Includes
      Include ${secrets.getTemplate "hydra-auth.conf"}
    '';

    # TODO: setup email
  };

  systemd.services.hydra-notify.serviceConfig.EnvironmentFile = secrets.getTemplate "hydra-email.env";

  services.nginx.virtualHosts."hydra.soopy.moe" = _utils.mkSimpleProxy {
    port = 3000;
    extraConfig = {
      useACMEHost = "bocchi.c.soopy.moe";
    };
  };
}
