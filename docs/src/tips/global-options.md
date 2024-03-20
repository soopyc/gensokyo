# "Global"/Extra Options
a way of passing additional options "globally" to modules is by using extraOpts.

in nix flakes, this is accomplished by using `specialArgs` in `nixosSystem`.

for example, check out these few lines in our flake.nix: [[source]](https://github.com/soopyc/nix-on-koumakan/blob/492dfaa01808c2aa5dbb2d8223163e92bcef673b/flake.nix#L29-L34)

```nix
# note: unrelated attributes stripped and removed.
# note2: this code is now out of date from our code, but can still be referenced.
{
  outputs = { ... }:{
    nixosConfigurations = {
      koumakan = lib.nixosSystem {
        specialArgs = {
          _utils = (import ./global/utils.nix) { inherit pkgs; };

          someOtherArg = {thisCanBe = "LiterallyAnything";};
        };
      };
    };
  };
}
```

With this, you can now do this in other imported nixos modules.

```nix
{ someOtherArg, ... }: {
  users.users.${someOtherArg} = {};
}
```

this avoids the horror of `import ../../../utils/bar.nix;` and various other things.

refer to [nixpkgs:nixos/lib/eval-config.nix] and [nixpkgs:lib/modules.nix#122] for more info

*pointers by \@natsukagami*

[nixpkgs:lib/modules.nix#122]: https://github.com/NixOS/nixpkgs/blob/6e68daefde56a7a8e6fe7c3ca9ceeb436294bb9f/lib/modules.nix#L122
[nixpkgs:nixos/lib/eval-config.nix]: https://github.com/NixOS/nixpkgs/blob/5054472759a3b0df8e18cfe4031a5eff92d4cdc3/nixos/lib/eval-config.nix
