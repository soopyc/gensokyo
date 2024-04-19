{
  config,
  inputs,
  ...
}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    verbose = true;

    sharedModules = [
      inputs.catppuccin.homeManagerModules.catppuccin
    ];

    extraSpecialArgs = {
      inherit (config.gensokyo) traits;
    };
  };
}
