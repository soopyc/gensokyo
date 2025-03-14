{
  _utils,
  config,
  ...
}: let
  secrets = _utils.setupSecrets config {
    namespace = "tangled";
    secrets = ["knot/key"];
  };
in {
  imports = [
    secrets.generate

    (secrets.mkTemplate "knotserver.env" ''
      KNOT_SERVER_SECRET=${secrets.placeholder "knot/key"}
    '')
  ];

  services.tangled-knotserver = {
    enable = true;
    gitUser = "knot";

    repo.mainBranch = "meow";
    server = {
      hostname = "enanan.staging.soopy.moe";
      listenAddr = "127.0.0.1:34195";
      internalListenAddr = "127.0.0.1:34196";
    };

    extraSshdConfig = ''
      Banner none
      PasswordAuthentication no
      KbdInteractiveAuthentication no
    '';
    environmentFile = secrets.getTemplate "knotserver.env";
  };

  services.nginx.virtualHosts."enanan.staging.soopy.moe" = _utils.mkSimpleProxy {
    port = 34195;
    extraConfig = {
      useACMEHost = null;
      enableACME = true;
    };
  };
}
