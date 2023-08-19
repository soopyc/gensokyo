{ config, ... }:

{
  # PostgreSQL only certificate
  security.acme.certs."phant.soopy.moe" = {
    group = "postgres";
    postRun = ''
      systemctl restart postgresql
    '';
  };

  # https://nixos.org/manual/nixos/stable/#module-security-acme-root-owned
  systemd.services.postgresql = {
    requires = ["acme-finished-phant.soopy.moe.target"];
    serviceConfig.LoadCredential = let
      certDir = config.security.acme.certs."phant.soopy.moe".directory;
    in [
      "cert.pem:${certDir}/cert.pem"
      "key.pem:${certDir}/key.pem"
    ];
  };
}
