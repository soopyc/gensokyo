{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./ssh.nix
    ./lazygit.nix
    ./editors.nix
  ];

  home.packages = with pkgs; [
    mdbook
    mdbook-admonish
    mdbook-pagetoc
  ];
}
