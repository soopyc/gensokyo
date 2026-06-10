{
  _utils,
  ...
}:
{
  services.tangled-knotserver = {
    enable = true;
    user = "knot";

    repo.mainBranch = "meow";
    server = {
      hostname = "enanan.staging.soopy.moe";
      listenAddr = "127.0.0.1:34195";
      internalListenAddr = "127.0.0.1:34196";
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
    port = 34195;
    websockets = true;
    extraConfig = {
      useACMEHost = null;
      enableACME = true;
    };
  };
}
