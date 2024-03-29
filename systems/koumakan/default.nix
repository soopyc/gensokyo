{
  lib,
  utils,
  inputs,
  sopsDir,
  ...
}:
lib.nixosSystem {
  system = "x86_64-linux";

  # see docs/tips_n_tricks.md#extra_opts for syntax
  # see docs/utils.md for functions
  specialArgs = {
    inherit inputs sopsDir;
    _utils = utils {
      inherit inputs;
      system = "x86_64-linux";
    };
  };

  modules = [
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.attic.nixosModules.atticd
    inputs.sops-nix.nixosModules.sops
    inputs.mystia.nixosModules.fixups
    inputs.mystia.nixosModules.vmauth

    ./configuration.nix
  ];
}
