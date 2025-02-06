{
  lib,
  inputs,
  ...
}: let
  utils = import ../global/utils.nix;

  mkSystem = hostname: system:
    lib.nixosSystem {
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
          nixpkgs.hostPlatform = lib.mkDefault system; # ensure we detect conflicts
        }
      ];
    };
in {
  koumakan = mkSystem "koumakan" "x86_64-linux";
  satori = mkSystem "satori" "x86_64-linux";
  renko = mkSystem "renko" "x86_64-linux";

  # cloud servers
  bocchi = mkSystem "bocchi" "x86_64-linux";
  kita = mkSystem "kita" "x86_64-linux";
  ryo = mkSystem "ryo" "x86_64-linux";
  nijika = mkSystem "nijika" "x86_64-linux";
}
