{ ... } :
{
  networking.networkmanager.ethernet.macAddress = builtins.readFile ../creds/nma.cry;
}
