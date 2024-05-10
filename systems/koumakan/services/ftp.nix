# {inputs, config, hostname, ...}: {
{...}: {
  services.sftpgo = {
    enable = true;

    settings = {
      common = {
        upload_mode = 2;
      };

      # data_provider = {
      #   driver = "postgresql";
      # };

      ftpd.bindings = [
        {
          port = 21;
          address = "192.168.8.16";
        }
      ];

      httpd.bindings = [
        {
          address = "192.168.8.16";
          port = 38562;
        }
      ];

      mfa.totp = [
        {
          name = "totp_sha256";
          issuer = "Gensokyo File Shares";
          algo = "sha256";
        }
      ];
    };
  };
}
