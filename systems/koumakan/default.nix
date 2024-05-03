{
  lib,
  utils,
  inputs,
  sopsDir,
  ...
}: let
  system = "x86_64-linux";
in
  lib.nixosSystem rec {
    inherit system;

    # see docs/tips_n_tricks.md#extra_opts for syntax
    # see docs/utils.md for functions
    specialArgs = {
      inherit inputs sopsDir;
      _utils = utils {
        inherit inputs system;
      };
    };

    modules = [
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.attic.nixosModules.atticd
      inputs.mystia.nixosModules.fixups
      inputs.mystia.nixosModules.vmauth

      ../../global
      ./configuration.nix

      {
        home-manager.extraSpecialArgs = specialArgs;
      }
    ];
  }
