{ _utils, ... }:

{
  services.atticd = {
    enable = true;
    credentialsFile = "/etc/atticd.env";

    settings = {
      listen = "127.0.0.1:38191";
    };
  };

  services.nginx.virtualHosts."nonbunary.soopy.moe" = _utils.mkSimpleProxy {
    port = 38191;
  };
}
