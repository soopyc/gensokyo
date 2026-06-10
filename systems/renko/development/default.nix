{ pkgs, ... }:
{
  imports = [
    ./docker.nix
    ./postgresql.nix
  ];

  environment.systemPackages = with pkgs; [
    android-tools
  ];
}
