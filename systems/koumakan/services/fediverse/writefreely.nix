{
  config,
  _utils,
  lib,
  # inputs,
  # pkgs,
  ...
}:
{
  services.writefreely = {
    enable = true;
    # package = inputs.nixpkgs-wf.legacyPackages.${pkgs.system}.writefreely;
    host = "words.soopy.moe";
    settings = {
      server.port = 31294;
      app = {
        host = "https://${config.services.writefreely.host}"; # annoying
        site_name = "Kourindou";
        site_description = "Words of Gensokyo, sprinkled with a little bit of technology";

        max_blogs = 0;
        open_registration = false;
        user_invites = "user";
        default_visibility = "public";

        federation = false;
        public_stats = true;
        min_username_len = 5;
        local_timeline = true;
      };
    };
    nginx.enable = true;
    admin.name = "soopyc";
  };

  services.nginx.virtualHosts.${config.services.writefreely.host} = _utils.mkVhost {
    forceSSL = lib.mkForce true;
    useACMEHost = "fedi.c.soopy.moe";
  };
}
