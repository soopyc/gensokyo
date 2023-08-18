{
  description = "Gensokyo system configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    attic.url = "github:zhaofengli/attic";
  };

  outputs = { nixpkgs, home-manager, lanzaboote, ... }:
  let
    pkgs = import nixpkgs {};
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      koumakan = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            # see docs/tips_n_tricks.md#extra_opts for syntax
            # see docs/utils.md for functions
            _module.args = {
              _utils = (import ./global/utils.nix) { inherit pkgs; };
            };
          }
          lanzaboote.nixosModules.lanzaboote
          
          ./systems/koumakan/configuration.nix
        ];
      };
    };
  };
}
