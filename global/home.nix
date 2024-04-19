{
  config,
  ...
}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    verbose = true;

    extraSpecialArgs = {
      inherit (config.gensokyo) traits;
    };
  };
}
