{ ... }:
{
  imports = [
    ./keine.nix
  ];

  services.nginx.virtualHost."_" = {
    default = true;
    locations."/".return = "301 https://gensokyo.soopy.moe";
  };
}
