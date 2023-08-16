# tops and bottoms
this document outlines things that i learned from various sources and some pure guesswork

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
overlays are useful when you want to refer to refer to a package globally.

the gist of overlays is as thus:

> overlay is just `prev: final: {}` functions where dumbed down idea is
> that you do pkg = prev.pkg.override and refer to everything else from
> final
>
> idea is like final = prev // overlay(prev, final)
> (it's a recursive definition)

(poorly made) example overlays can be found [here](https://github.com/soopyc/nixos-config/blob/master/overlays/discord-canary.nix)

*note: replace `self: super:` with `prev: final:` for consistency*

*concept and content by \@natsukagami*

## extra opts
a way of passing additional options globally to modules is by using extraOpts.

<!-- find a way that we can still use this apart from in nixos config-->
for example, check out this line in our flake.nix:

https://github.com/soopyc/nix-on-koumakan/blob/3c32de4a69a5963f9cd83bf5cf0dccea88f9f36c/flake.nix#L22-L26

this avoids the horror of `import ../../../utils/bar.nix;`

refer to [nixpkgs:nixos/lib/eval-config.nix] and [nixpkgs:lib/modules.nix#122] for more info

note that extraArgs is deprecated, so you will need to use config._module.args (i have no idea
how this works)

*pointers by \@natsukagami*

# @ (at) syntax
very simple.

```nix
args@{a, b, c, ...}: {
  # args.a and a are the same
}
```

## nginx regex location
```nix
  locations."~ \.php$".extraConfig = ''
  # balls
  '';
```
from [nixos wiki](https://nixos.wiki/wiki/Nginx#LEMP_stack)


<!--links-->
[nixpkgs:lib/modules.nix#122]: https://github.com/NixOS/nixpkgs/blob/6e68daefde56a7a8e6fe7c3ca9ceeb436294bb9f/lib/modules.nix#L122
[nixpkgs:nixos/lib/eval-config.nix]: https://github.com/NixOS/nixpkgs/blob/5054472759a3b0df8e18cfe4031a5eff92d4cdc3/nixos/lib/eval-config.nix
