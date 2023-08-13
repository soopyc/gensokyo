{ ... } :
{
  networking.networkmanager.ethernet.macAddress = builtins.readFile ./nma.cry;
}
