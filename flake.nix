{
  description = "Gensokyo system configurations";

  nixConfig = rec {
    extra-substituters = [
      "https://nonbunary.soopy.moe/gensokyo-global"
      "https://nonbunary.soopy.moe/gensokyo-systems"
    ];

    extra-trusted-substituters = extra-substituters;

    extra-trusted-public-keys = [
      "gensokyo-global:XiCN0D2XeSxF4urFYTprR+1Nr/5hWyydcETwZtPG6Ec="
      "gensokyo-systems:r/Wx649dPuQrCN9Pgh3Jic526zQNk3oWMqYJHnob/Ok="
    ];

    fallback = true;
  };

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
