# impure alert
{
  name,
  content,
}:
with import <nixpkgs> {system = builtins.currentSystem;}; let
  yaml = formats.yaml {};
in
  yaml.generate name content
