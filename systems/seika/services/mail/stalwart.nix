{
  inputs,
  _system,
  ...
}:
{
  services.stalwart-minimal = {
    enable = true;
    package = inputs.nixpkgs-unstable.legacyPackages.${_system}.stalwart_0_16;

    credentials = { };
  };
}
