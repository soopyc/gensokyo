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
      inputs.catppuccin.homeModules.catppuccin
    ];

    extraSpecialArgs = {
      inherit (config.gensokyo) traits;
    };
  };
}
