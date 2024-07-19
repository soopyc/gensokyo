{
  lib,
  inputs,
  ...
}: let
  utils = import ../global/utils.nix;

  mkSystem = hostname: system:
    lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;

        hostname = hostname;
        _utils = utils {inherit inputs system;};
      };

      modules = [
        ../global
        ./${hostname}/configuration.nix
        ./${hostname}/hardware-configuration.nix

        {
          home-manager.extraSpecialArgs = {inherit inputs;};
          networking.hostName = hostname;
        }
      ];
    };
in {
  koumakan = mkSystem "koumakan" "x86_64-linux";
  satori = mkSystem "satori" "x86_64-linux";
  renko = mkSystem "renko" "x86_64-linux";
  bocchi = mkSystem "bocchi" "x86_64-linux";
}
