{
  description = "Gensokyo system configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    attic = {
      url = "github:zhaofengli/attic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mystia = {
      url = "github:soopyc/mystia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
  let
    # pkgs = import nixpkgs {};
    _utils = import ./global/utils.nix {};
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      koumakan = (import ./systems/koumakan { inherit _utils lib inputs; });
    };

    # formatter.x86_64-linux = pkgs.alejendra;
  };
}
