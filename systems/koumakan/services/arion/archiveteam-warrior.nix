{
  virtualisation.arion.projects.at-warrior.settings = {
    services.atw.service = {
      image = "atdr.meo.ws/archiveteam/warrior-dockerfile";
      ports = ["127.0.0.1:35842:8001"];
      restart = "unless-stopped";
    };

    # TODO: make this automatic somewhere in ./default.nix
    docker-compose.raw = {
      # arion doesn't have this in the module system --2025-07-06
      # https://github.com/compose-spec/compose-spec/blob/main/spec.md#pull_policy
      services.atw.pull_policy = "weekly";
    };
  };
}
