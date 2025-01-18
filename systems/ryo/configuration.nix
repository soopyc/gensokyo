# ryo because empty-headed. also btr naming scheme.
# DO NOT copy anything done on this host, it's insecure by design.
{...}: {
  imports = [];

  gensokyo.presets.vmetrics = true;
  zramSwap.enable = true;
  system.stateVersion = "23.11";
}
