{ pkgs, ... }:
{
  imports = [
    ./nixvim.nix
  ];

  environment.systemPackages = with pkgs; [
    helix
  ];
}
