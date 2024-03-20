# Pitfalls

"There are pitfalls in this language???!??!?"

*-- The uninitiated*

## importing nixpkgs with an empty attrset

ever had this in your flake.nix

```nix
{
  outputs = { nixpkgs, ... }@inputs: let
    pkgs = import nixpkgs {};
    lib = nixpkgs.lib;
  in {
    # ...
  };
}
```

... and got fucked with this?
```shell
error:
       … while checking flake output 'nixosConfigurations'

         at /nix/store/lz2ra1180qfffmpwg41jpyg1z602qdgx-source/flake.nix:50:5:

           49|   in {
           50|     nixosConfigurations = {
             |     ^
           51|       koumakan = (import ./systems/koumakan { inherit pkgs lib inputs; });

       … while checking the NixOS configuration 'nixosConfigurations.koumakan'

         at /nix/store/lz2ra1180qfffmpwg41jpyg1z602qdgx-source/flake.nix:51:7:

           50|     nixosConfigurations = {
           51|       koumakan = (import ./systems/koumakan { inherit pkgs lib inputs; });
             |       ^
           52|     };

       (stack trace truncated; use '--show-trace' to show the full trace)

       error: attribute 'currentSystem' missing

       at /nix/store/5c0k827yjq7j24qaq8l2fcnsxp7nv8v1-source/pkgs/top-level/impure.nix:17:43:

           16|   # (build, in GNU Autotools parlance) platform.
           17|   localSystem ? { system = args.system or builtins.currentSystem; }
             |                                           ^
           18|
```

just don't!!!11 remove the pkgs definition. (note that this only applies to `pkgs = import nixpkgs {};`)

explanation

> you shouldn't ever really import nixpkgs with an empty attrset either
>
> that causes it to fall back on guessing your system using `builtins.currentSystem`,
> which is impure and so not allowed in pure evaluation mode
>
> —- @getchoo
