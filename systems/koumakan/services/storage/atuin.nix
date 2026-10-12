{ _utils, config, ... }:
{
  gensokyo.ports.atuin = 34892;
  services.atuin = {
    enable = true;
    database.createLocally = true;
    port = config.gensokyo.ports.atuin;
    openRegistration = true;
  };

  services.nginx.virtualHosts."atuin.soopy.moe" = _utils.mkSimpleProxy {
    port = config.gensokyo.ports.atuin;
  };
}
