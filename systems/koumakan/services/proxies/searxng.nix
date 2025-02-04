{
  _utils,
  config,
  lib,
  ...
}: let
  secrets = _utils.setupSecrets config {
    namespace = "searxng";
    secrets = ["secret"];
  };
in {
  imports = [
    secrets.generate
    (secrets.mkTemplate "searxng.env" ''
      SEARXNG_SECRET=${secrets.placeholder "secret"}
    '')
  ];

  users.users.nginx.extraGroups = [config.users.groups.searx.name];

  services.searx = {
    enable = true;
    runInUwsgi = true;
    environmentFile = secrets.getTemplate "searxng.env";
    redisCreateLocally = true;
    uwsgiConfig = {
      http = "/run/searx/searxng.sock";
      chmod-socket = "660";
      disable-logging = true;
    };

    # FIXME: this doesn't work atm because it's not read i think? add a symlink from /run/searx/limiter.toml pointing to /etc/searx/limiter.toml
    limiterSettings = {
      real_ip = {
        x_for = 1;
        ipv4_prefix = 32;
        ipv6_prefix = 48;
      };
      botdetection.ip_limit.link_token = true;
      botdetection.ip_lists.pass_searxng_org = true;
    };

    settings = {
      use_default_settings = true;
      general.contact_Url = "mailto:cassie@soopy.moe";

      preferences.lock = lib.singleton "infinite_scroll";
      ui.infinite_scroll = false;
      ui.search_on_category_select = false;

      server = {
        secret_key = "@SEARXNG_SECRET@";
        public_instance = true;
        base_url = "https://s.soopy.moe";
        image_proxy = true;
        limiter = true;
        http_protocol_version = "1.1";
      };

      search = {
        autocomplete = "duckduckgo";
        favicon_resolver = "duckduckgo";
      };

      engines = [
        {
          name = "annas archive";
          disabled = false;
        }
        {
          name = "nixos wiki";
          disabled = false;
        }
        {
          name = "cppreference";
          disabled = false;
        }
        {
          name = "ddg definitions";
          disabled = false;
        }
        {
          name = "fdroid";
          disabled = false;
        }
        {
          name = "lobste.rs";
          disabled = false;
        }
        {
          name = "nyaa";
          disabled = false;
        }
        {
          name = "pub.dev";
          disabled = false;
        }
        {
          name = "nixos discourse";
          engine = "discourse";
          shortcut = "dno";
          base_url = "https://discourse.nixos.org";
          categories = ["it" "q&a"];
        }
      ];
    };
  };

  services.nginx.virtualHosts."s.soopy.moe" = _utils.mkSimpleProxy {
    socketPath = "/run/searx/searxng.sock";
  };
}
