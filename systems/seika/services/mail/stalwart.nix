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
    startupConfig = {
      blobSize = 1024;
    };

    # startupConfigFile = "/var/lib/stalwart/bootstrap.json"; # delete file and uncomment to use bootstrap mode
  };
}
