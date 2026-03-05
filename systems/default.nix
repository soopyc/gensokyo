{
  lib,
  inputs,
  ...
}:
let
  utils = import ../global/utils.nix;

  mkSystem =
    hostname: system: hostId:
    lib.nixosSystem {
      specialArgs = {
        inherit inputs hostname;

        _utils = utils { inherit inputs system; };
      };

      modules = [
        ../global
        ./${hostname}/configuration.nix
        ./${hostname}/hardware-configuration.nix

        {
          networking = {
            inherit hostId;
            hostName = hostname;
          };

          home-manager.extraSpecialArgs = { inherit inputs; };
          nixpkgs.hostPlatform = lib.mkDefault system; # ensure we detect conflicts
        }
      ];
    };
in
{
  # when onboarding a new device, generate a 8-char hostId with openssl rand -hex 4
  # this is not equal to the machine-id.

  youmu = mkSystem "youmu" "x86_64-linux" "f6050bfd";
  koumakan = mkSystem "koumakan" "x86_64-linux" "58fb4840";
  satori = mkSystem "satori" "x86_64-linux" "e386e92b";
  renko = mkSystem "renko" "x86_64-linux" "760c2249";

  # cloud servers
  kita = mkSystem "kita" "x86_64-linux" "05a75d20";
  # ryo = mkSystem "ryo" "x86_64-linux";
  # nijika = mkSystem "nijika" "aarch64-linux";
}
