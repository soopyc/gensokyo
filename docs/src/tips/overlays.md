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
