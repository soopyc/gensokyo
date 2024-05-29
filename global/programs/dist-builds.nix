# Like distcc but not really
{
  lib,
  inputs,
  config,
  hostname,
  ...
}: let
  mkBuildMachines = attr: let
    cleanAttr = builtins.removeAttrs attr [hostname];
  in
    lib.mapAttrsToList (name: value:
      {
        hostName = name;
        system = "x86_64-linux";

        protocol = "ssh";
        sshUser = "builder";
        sshKey = config.sops.secrets.builder_key.path;

        speedFactor = 1;
        maxJobs = 2;
      }
      // value)
    cleanAttr;
in {
  sops.secrets.builder_key = {
    sopsFile = inputs.self + "/creds/sops/global/id_builder";
    format = "binary";
  };

  nix.distributedBuilds = true;
  nix.buildMachines = mkBuildMachines {
    # localhost.protocol = null;
    renko = {
      speedFactor = 5;
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUoreGNleXA4YnRVNnd0dThpRUFKMkZ4cm5rZlBsS1M3TWFJL2xLT0ZuUDEgcm9vdEByZW5rbwo=";
    };
    bocchi.publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSVBoNklmemNReHE0Si92aW1BY1JVbW5qUzZhRkN0ay9TeXRnN1lzUnNCVlkgCg==";
  };

  services.openssh.extraConfig = lib.mkAfter ''
    Match User builder
      Banner none
      PasswordAuthentication no
      KbdInteractiveAuthentication no
  '';
}
