# Overlays
overlays are useful when you want to refer to a package globally, or to fix a broken package locally.

you might also want to use overlays when something hasn't made it into nixos-unstable or whatever you're on yet, but you
desparately need said thing.

the gist of overlays is as thus:

> overlay is just `final: prev: {}` functions
>
> dumbed down idea is that you do `pkg = prev.pkg.override` and
> refer to everything else from `final`
>
> idea is like final = prev // overlay(prev, final)
>
> (it's a recursive definition)

(poorly made) example overlays can be found [here](https://github.com/soopyc/nixos-config/blob/master/overlays/discord-canary.nix)

~~currently in-use and slightly better overlays can be found in this repo! head over to /overlays to see them.~~

*note: replace `self: super:` with `final: prev:` for consistency*

UPDATE: we don't really use overlays anymore. If you'd like an example, please reach out and we can add some here.

*concept and quote content by @natsukagami*

```admonish info
If you write 3rd party nix modules, it is a bad idea to do overlays as the performance impact propagates to everyone
in the stream. See [this article that talks about overlays](
	https://zimbatm.com/notes/1000-instances-of-nixpkgs
).
```

## Overlaying python packages
In some situations a python package may be bugged. This might have been fixed upstream by Nixpkgs devs, but has not reached `nixos-unstable` or whatever.

While overriding normal packages is relatively straightforward, doing so with python is most definitely not.

We have done this recently with the help of [Scrumplex] (thank you!) because a package was broken on nixos-unstable. Someone made a fix and it was merged, but it has yet to make it to nixos-unstable. This was blocking our systems from building so we decided to just say sod it, we're doing this.

Again, overriding simple packages that are not inside any package groups is wildly easier than this operation. Since not every package group is the same, this sample only focuses on Python because we only have experience with that.

Copy-paste the new package definiton next to the place where you're defining the overlay. We will be referencing it as `./package.nix`.

```nix
final: prev: {
  # this does not work because the package uses python3Packages. this is defining standalone package.
  pyscard = prev.python3Packages.callPackage ./package.nix {};

  python3 = prev.python3.override {
    self = final.python3;

    # to their credit we do have this thing here which was already great
    packageOverrides = (final': prev': {
      # we cannot use final'.pkgs.callPackage here because it's missing buildPythonModule or something.
      pyscard = final.python3Packages.callPackage ./package.nix {
        inherit (final.darwin.apple_sdk.frameworks) PCSC; # apple carp
      };
    });
  };

  # probably some `rec` carp
  # IMPORTANT: you need this! this is needed to let nix know we want to use our overrided python3 package earlier.
  #            if you don't add this, you will still be building the old package like nothing changed at all.
  #            Yes, nix is this sad.
  python3Packages = final.python3.pkgs;
}
```

A full example is accessible [here](https://github.com/soopyc/gensokyo/tree/53fcb9bdeeede6e250c84a05ff8c6c1aca9b5fe6/global/overlays/temp/pyscard).

[Scrumplex]: https://github.com/scrumplex
