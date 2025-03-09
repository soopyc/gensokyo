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
    mystia.url = "github:soopyc/mystia/nixos/anubis";
    nixpkgs.follows = "mystia/nixpkgs";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    nixos-hardware.url = "github:soopyc/nixos-hardware/apple-t2-updates";
    catppuccin.url = "github:catppuccin/nix";
    hydra.url = "github:NixOS/hydra/881462bb4efeb28c970aab7d3d0515c7b7c8b5de";
    buildbot-nix.url = "github:nix-community/buildbot-nix";

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
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

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    treefmt-nix,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;

    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    forAllSystems = fn: lib.genAttrs systems (system: fn nixpkgs.legacyPackages.${system});
    treefmt = forAllSystems (pkgs: treefmt-nix.lib.evalModule pkgs ./nix/treefmt.nix);
  in {
    lib.x86_64-linux = import ./global/utils.nix {
      inherit inputs;
      system = "x86_64-linux";
    };

    packages.x86_64-linux = let
      system = "x86_64-linux";
    in {
      brcmfmac = let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["brcm-mac-firmware"];
        };
      in
        pkgs.callPackage ./vendor/brcmfmac {};
    };

    nixosConfigurations = import systems/default.nix {inherit inputs lib;};

    devShells = forAllSystems (pkgs: import ./nix/devshell.nix {inherit pkgs inputs;});

    checks = forAllSystems (pkgs:
      (import ./nix/checks.nix {inherit pkgs inputs;})
      // {
        formatting = treefmt.${pkgs.system}.config.build.check self;
      });

    hydraJobs =
      {inherit (self) checks;}
      // (lib.mapAttrs'
        (
          hostname: system:
            lib.nameValuePair "nixosSystem.${hostname}" system.config.system.build.toplevel
        )
        self.nixosConfigurations);

    formatter = forAllSystems (pkgs: treefmt.${pkgs.system}.config.build.wrapper);
  };
}
