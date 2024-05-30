# Like distcc but not really
{
  lib,
  inputs,
  config,
  hostname,
  ...
}: let
  baselineFeatures = [
    "big-parallel"
  ];

  mkBuildMachines = attr: let
    cleanAttr = builtins.removeAttrs attr [hostname];
  in
    lib.mapAttrsToList (name: value:
      {
        hostName = name + ".mist-nessie.ts.net";

        protocol = "ssh";
        sshUser = "builder";
        sshKey = config.sops.secrets.builder_key.path;

        speedFactor = 1;
        maxJobs = 2;
        supportedFeatures = baselineFeatures;

        systems = ["i686-linux" "x86_64-linux"];
      }
      // value)
    cleanAttr
    ++ [
      {
        hostName = "localhost";
        protocol = null;
        speedFactor = 1;
        maxJobs = 1;
        system = "x86_64-linux";
        supportedFeatures = baselineFeatures;
      }
    ];
in {
  sops.secrets.builder_key = {
    sopsFile = inputs.self + "/creds/sops/global/id_builder";
    format = "binary";
  };

  nix.distributedBuilds = true;
  nix.buildMachines = mkBuildMachines {
    renko = {
      supportedFeatures = baselineFeatures ++ ["kvm" "nixos-test"];
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
