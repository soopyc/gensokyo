# Misc tips

This page contains stuff that ~~I couldn't be bothered to move to the new format~~ is probably outdated or just short tips.

*previously: tops and bottoms*

## @ (at) syntax
very simple.

```nix
args@{a, b, c, ...}: {
  # args.a and a are the same
  some = "value";
}
```

## nginx regex location
```nix
{
  locations."~ \.php$".extraConfig = ''
    # balls
  '';
}
```
from [nixos wiki](https://nixos.wiki/wiki/Nginx#LEMP_stack)

## adding a package with an overlay to a package set

for package sets with a scope, you will have to do something like
```nix
final: prev: {
  nimPackages = prev.nimPackages.overrideScope (final': prev': {
    sha1 = final'.callPackage ./sha1.nix {};
    oauth = final'.callPackage ./oauth.nix {};
  });
}
```
There's an alternative method that i used to use here:

https://github.com/soopyc/nix-on-koumakan/blob/30e65402d22b000a3b5af6c9e5ea48a2b58a54e0/overlays/nim/oauth/default.nix

however i do not think that's the best way lol

## what the hell is an IFD??
IFD stands for import from derivation.

*nixos/nixpkgs really need better and significantly less scattered documentation while improving manual readability.*

# Useful links

Builtin stdlib functions search engine: https://noogle.dev/
