# ryo because empty-headed. also btr naming scheme.
# DO NOT copy anything done on this host, it's insecure by design.
{ ... }:
{
  imports = [
    ./services
  ];

  gensokyo.presets = {
    vmetrics = true;
    certificates = true;
    nginx = true;
  };
  swapDevices = [
    {
      device = "/Swapfile";
      size = 2048;
    }
  ];
  system.stateVersion = "23.11";
}
