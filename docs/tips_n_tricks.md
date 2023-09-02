# tops and bottoms
this document outlines things that i learned from various sources and some pure guesswork

> To learn Nix is to learn to suffer, and to learn the way of numbing the pain
— Cassie circa. 2023

## overriding packages
the pill confused me and i thought i had to make overlays to do overrides but no

in packages (i.e. `environment.systemPackages`), just do
```nix
#-------8<-Snip-------
environment = {
  systemPackages = with pkgs; [
    (discord.override {withOpenASAR = true;})
    ()
  ];
};
#-------Snip->8-------
```

This works as well
```nix
security.sudo.package = (pkgs.sudo.override {withInsults = true;});
```

## overlays
overlays are useful when you want to refer to a package globally.

the gist of overlays is as thus:

> overlay is just `final: pref: {}` functions where dumbed down idea is
> that you do pkg = prev.pkg.override and refer to everything else from
> final
>
> idea is like final = prev // overlay(prev, final)
> (it's a recursive definition)

(poorly made) example overlays can be found [here](https://github.com/soopyc/nixos-config/blob/master/overlays/discord-canary.nix)

currently in-use and slightly better overlays can be found in this repo! head over to /overlays to see them.

*note: replace `self: super:` with `final: prev:` for consistency*

*concept and content by \@natsukagami*

## extra opts
a way of passing additional options globally to modules is by using extraOpts.

in nix flakes, this is accomplished by using `specialArgs` in `nixosSystem`.

for example, check out this line in our flake.nix:

https://github.com/soopyc/nix-on-koumakan/blob/492dfaa01808c2aa5dbb2d8223163e92bcef673b/flake.nix#L22-L28

this avoids the horror of `import ../../../utils/bar.nix;`

refer to [nixpkgs:nixos/lib/eval-config.nix] and [nixpkgs:lib/modules.nix#122] for more info

*pointers by \@natsukagami*

# @ (at) syntax
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

# adding a package with an overlay to a package set

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

## Useful links

Builtin stdlib functions search engine: https://noogle.dev/


<!--links-->
[nixpkgs:lib/modules.nix#122]: https://github.com/NixOS/nixpkgs/blob/6e68daefde56a7a8e6fe7c3ca9ceeb436294bb9f/lib/modules.nix#L122
[nixpkgs:nixos/lib/eval-config.nix]: https://github.com/NixOS/nixpkgs/blob/5054472759a3b0df8e18cfe4031a5eff92d4cdc3/nixos/lib/eval-config.nix
