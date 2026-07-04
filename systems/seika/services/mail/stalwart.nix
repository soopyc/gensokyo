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
      "@type" = "RocksDb";
      blobSize = 1024;
      bufferSize = 134217728;
      path = "/var/lib/stalwart/data";
      poolWorkers = null;
    };

    # startupConfigFile = "/var/lib/stalwart/bootstrap.json"; # delete file and uncomment to use bootstrap mode
  };
}
