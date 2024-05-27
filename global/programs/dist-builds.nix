# Like distcc but not really
{
  lib,
  inputs,
  config,
  ...
}: let
  mkBuildMachines = attr:
    lib.mapAttrsToList (name: value:
      {
        hostName = name;
        system = "x86_64-linux";

        protocol = "ssh-ng";
        sshUser = "builder";
        sshKey = config.sops.secrets.builder_key.path;

        speedFactor = 1;
        maxJobs = 2;
      }
      // value)
    attr;
in {
  sops.secrets.builder_key = {
    sopsFile = inputs.self + "/creds/sops/global/id_builder";
    format = "binary";
  };

  nix.distributedBuilds = true;
  nix.buildMachines = mkBuildMachines {
    renko.speedFactor = 5;
    bocchi = {};
  };
}
