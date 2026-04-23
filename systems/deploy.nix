# this file is disconnected from the nixos configurations.
# it is only used for deploy-rs definitions.
{
  self,
  nixpkgs,
  deploy-rs,
  ...
}:
let
  lib = nixpkgs.lib;
  ciArch = "x86_64-linux";
  mkDeploy =
    name: arch: extraOpts:
    lib.recursiveUpdate {
      hostname = name;
      profiles.system = {
        path = deploy-rs.lib.${ciArch}.activate.nixos self.nixosConfigurations.${name};
      };
      remoteBuild = if arch != ciArch then true else false;
    } extraOpts;
in
{
  deploy = {
    user = "root";
    interactiveSudo = true;
    autoRollback = false; # some services randomly fail but doesn't affect things.
    magicRollback = true; # this is good though cuz we are stupid sometimes.

    nodes = {
      # TODO: try to dedupe this with /systems/default.nix
      youmu = mkDeploy "youmu" "x86_64-linux" { };
      koumakan = mkDeploy "koumakan" "x86_64-linux" { };
      # satori = mkDeploy "satori" "x86_64-linux" { };
      renko = mkDeploy "renko" "x86_64-linux" { };
      kita = mkDeploy "kita" "x86_64-linux" { };
      nijika = mkDeploy "nijika" "aarch64-linux" { };
    };
  };

  # scary 30GB download??
  # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
}
