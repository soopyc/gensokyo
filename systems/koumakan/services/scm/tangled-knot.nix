{
  _utils,
  config,
  ...
}:
{
  gensokyo.ports = {
    tangled-knot = 34195;
    tangled-knot-internal = 34196;
  };
  services.tangled-knotserver = {
    enable = true;
    user = "knot";

    repo.mainBranch = "meow";
    server = {
      hostname = "enanan.staging.soopy.moe";
      listenAddr = "127.0.0.1:${toString config.gensokyo.ports.tangled-knot}";
      internalListenAddr = "127.0.0.1:${toString config.gensokyo.ports.tangled-knot-internal}";
    };

    extraConfig = {
      KNOT_SERVER_OWNER = "did:plc:jmr637khkdb2fdxxvoyj672m";
      APPVIEW_ENDPOINT = "https://tangled.org";
    };

    extraSshdConfig = ''
      Banner none
      PasswordAuthentication no
      KbdInteractiveAuthentication no
    '';
  };

  services.nginx.virtualHosts."enanan.staging.soopy.moe" = _utils.mkSimpleProxy {
    port = config.gensokyo.ports.tangled-knot;
    websockets = true;
    extraConfig = {
      useACMEHost = null;
      enableACME = true;
    };
  };
}
