# impure alert
{
  name,
  content,
}:
let
  pkgs = import <nixpkgs> { }; # uses builtins.currentSystem
in
pkgs.writeText name (builtins.toJSON content)
