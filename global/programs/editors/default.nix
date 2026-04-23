{ pkgs, ... }:
{
  imports = [
    ./nixvim.nix
  ];

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
    helix
  ];
}
