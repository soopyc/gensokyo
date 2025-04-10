{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.kmymoney
  ];
}
