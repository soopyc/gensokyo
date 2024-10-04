{
  description = "Gensokyo system configurations";

  nixConfig = {
    extra-substituters = [
      "https://cache.soopy.moe"
    ];

    extra-trusted-public-keys = [
      "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo="
    ];
    allow-import-from-derivation = true;
    fallback = true;
  };

  inputs = {
    mystia.url = "github:soopyc/mystia";

    nixpkgs.follows = "mystia/nixpkgs";
    nixpkgs-wf.url = "github:soopyc/nixpkgs/wf-test";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    nixos-hardware.url = "github:soopyc/nixos-hardware/apple/t2/extract-tiny-dfr";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
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

    hydra.url = "github:soopyc/hydra/master";
  };

  outputs = {nixpkgs, ...} @ inputs: let
    lib = nixpkgs.lib;

    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    forAllSystems = fn: lib.genAttrs systems (s: fn nixpkgs.legacyPackages.${s});
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

    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShellNoCC {
        packages = [
          (pkgs.python311.withPackages (p: [p.requests]))
          pkgs.nixos-rebuild
          pkgs.nvd
        ];
      };
    });

    checks = forAllSystems (pkgs: {
      format-deadcode-check = pkgs.stdenvNoCC.mkDerivation {
        name = "format_deadcode_check";
        src = ./.;
        dontPatch = true;
        dontConfigure = true;

        buildInputs = with pkgs; [alejandra deadnix];
        buildPhase = ''
          set -euo pipefail
          echo "######## Checking flake ########"

          deadnix -f .
          alejandra -c . 2>/dev/null
          echo "All done!"
        '';

        installPhase = "touch $out";
      };
    });

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
