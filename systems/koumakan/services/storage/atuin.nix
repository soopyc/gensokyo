{_utils, ...}: {
  services.atuin = {
    enable = true;
    database.createLocally = true;
    port = 34892;
    openRegistration = true;
  };

  services.nginx.virtualHosts."atuin.soopy.moe" = _utils.mkSimpleProxy {
    port = 34892;
  };
}
