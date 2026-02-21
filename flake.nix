{
  description = "Gensokyo system configurations";

  nixConfig = {
    extra-substituters = [
      "https://cache.soopy.moe"
    ];

    extra-trusted-public-keys = [
      "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo="
    ];
    fallback = true;
  };

  inputs = {
    mystia.url = "github:soopyc/mystia";
    # nixpkgs.follows = "mystia/nixpkgs";
    nixpkgs.url = "https://nixpkgs.dev/channel/nixos-25.11";

    nixos-hardware.url = "github:soopyc/nixos-hardware/apple-t2-updates";
    catppuccin.url = "github:catppuccin/nix/release-25.05"; # TODO
    hydra.url = "github:NixOS/hydra";
    ghostty.url = "github:ghostty-org/ghostty";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      # sync with nixpkgs!
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    whitelisted-web = {
      url = "https://patchy.soopy.moe/soopyc/whitelisted-web/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tangled-core = {
      url = "git+https://tangled.org/tangled.org/core";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    knotserver-module = {
      url = "git+https://tangled.org/did:plc:jmr637khkdb2fdxxvoyj672m/knotserver-module/?ref=knot-fix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.tangledCore.follows = "tangled-core";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems =
        fn:
        lib.genAttrs systems (
          system:
          fn {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
          }
        );
      treefmt = forAllSystems ({ pkgs, ... }: treefmt-nix.lib.evalModule pkgs ./nix/treefmt.nix);
    in
    {
      lib.x86_64-linux = import ./global/utils.nix {
        inherit inputs;
        system = "x86_64-linux";
      };

      packages.x86_64-linux =
        let
          system = "x86_64-linux";
        in
        {
          brcmfmac =
            let
              pkgs = import nixpkgs {
                inherit system;
                config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "brcm-mac-firmware" ];
              };
            in
            pkgs.callPackage ./vendor/brcmfmac { };
        };

      nixosConfigurations = import systems/default.nix { inherit inputs lib; };

      devShells = forAllSystems ({ pkgs, ... }: import ./nix/devshell.nix { inherit pkgs inputs; });

      checks = forAllSystems (
        { pkgs, system }:
        (import ./nix/checks.nix { inherit pkgs inputs; })
        // {
          formatting = treefmt.${system}.config.build.check self;
        }
      );

      formatter = forAllSystems ({ system, ... }: treefmt.${system}.config.build.wrapper);

      _debug = {
        inherit inputs;
      };
    };
}
