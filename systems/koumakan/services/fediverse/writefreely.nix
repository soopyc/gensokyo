{config, _utils, ...}: {
  services.writefreely = {
    enable = true;
    host = "words.soopy.moe";
    settings = {
      server.port = 31294;
      app = {
        host = "https://${config.services.writefreely.host}";  # annoying
        site_name = "Kourindou";
        site_description = "Words of Gensokyo, sprinkled with a little bit of technology";

        max_blogs = 0;
        open_registration = false;
        user_invites = "user";
        default_visibility = "public";
      };
    };
    nginx.enable = true;
    admin.name = "soopyc";
  };

  services.nginx.virtualHosts.${config.services.writefreely.host} = _utils.mkVhost {
    useACMEHost = "fedi.c.soopy.moe";
  };
}
