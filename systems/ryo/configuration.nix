# ryo because empty-headed. also btr naming scheme.
# DO NOT copy anything done on this host, it's insecure by design.
{...}: {
  imports = [
    ./certificates
    ./services
  ];

  gensokyo.presets = {
    vmetrics = true;
    certificates = true;
    nginx = true;
  };
  zramSwap.enable = true;
  system.stateVersion = "23.11";
}
