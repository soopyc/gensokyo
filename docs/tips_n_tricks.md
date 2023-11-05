<!--
  vim:fileencoding=utf-8:foldmethod=marker
-->

# tops and bottoms
this document outlines things that i learned from various sources and some pure guesswork

> To learn Nix is to learn to suffer, and to learn the way of numbing the pain
>
> — Cassie circa. 2023

There might be more undocumented things. Interesting things are usually marked with `#‍ HACK:`.

Of course, I might completely miss stuff. in that case, feel free to open an issue.

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

## using sops-nix or other stuff to pass big chungus files to services with DynamicUser=true
afaik this is not possible.

The option that makes the most sense, LoadCredentials only supports files up to 1 MB in size.
([relevant documentation (`systemd.exec(5)`)](https://www.freedesktop.org/software/systemd/man/systemd.exec.html#LoadCredential=ID:PATH:~:text=Currently%2C%20an,is%20enforced))

without that option, we are only left with giving a user access to the file. doing that is not without
its pitfalls, however. we cannot get the dynamic user's id in a ExecStartPre hook with the + prefix. The
user is ran with root privileges and there are no signs of the final ephemeral user id. the same happens with
ones prefixed with `!`.

<!--
  This is a vim fold. press z+o to open, z+c to close.
  Terminal output {{{
-->
<details>
  <pre>
cassie in marisa in ~ via C v13.2.1-gcc via ☕ v17.0.8 took 1s
󰁹 97% at 22:04:18 ✗ 1 ➜ systemd-run -pPrivateTmp=true -pDynamicUser=true --property="SystemCallFilter=@system-service ~@privileged ~@resources" -pExecStartPre="+env" -pPrivateUsers=true -t bash
Running as unit: run-u1196.service
Press ^] three times within 1s to disconnect TTY.
LANG=en_US.UTF-8
PATH=/usr/local/sbin:/usr/local/bin:/usr/bin
LOGNAME=run-u1196
USER=run-u1196
INVOCATION_ID=df38607fae444d47971fa70b5f55d9a2
TERM=xterm-256color
SYSTEMD_EXEC_PID=620896
MEMORY_PRESSURE_WATCH=/sys/fs/cgroup/system.slice/run-u1196.service/memory.pressure
MEMORY_PRESSURE_WRITE=[...]
^C%
cassie in marisa in ~ via C v13.2.1-gcc via ☕ v17.0.8 took 2s
󰁹 97% at 22:04:30 ➜ systemd-run -pPrivateTmp=true -pDynamicUser=true --property="SystemCallFilter=@system-service ~@privileged ~@resources" -pExecStartPre="\!env" -pPrivateUsers=true -t bash
Running as unit: run-u1200.service
Press ^] three times within 1s to disconnect TTY.
LANG=en_US.UTF-8
PATH=/usr/local/sbin:/usr/local/bin:/usr/bin
LOGNAME=run-u1200
USER=run-u1200
INVOCATION_ID=f6ccef7b2d6a470aa734f0e326adb14a
TERM=xterm-256color
SYSTEMD_EXEC_PID=620992
MEMORY_PRESSURE_WATCH=/sys/fs/cgroup/system.slice/run-u1200.service/memory.pressure
MEMORY_PRESSURE_WRITE=[...]
^C%
cassie in marisa in ~ via C v13.2.1-gcc via ☕ v17.0.8 took 2s
󰁹 97% at 22:04:42 ➜ systemd-run -pPrivateTmp=true -pDynamicUser=true -pSystemCallFilter=@system-service -pSystemCallFilter=~@privileged -pSystemCallFilter=~@resources -pExecStartPre="\!bash -c 'echo \$UID'" -pPrivateUsers=true -t bash -c "ls"
Running as unit: run-u1236.service
Press ^] three times within 1s to disconnect TTY.
0
^C%
cassie in marisa in ~ via C v13.2.1-gcc via ☕ v17.0.8 took 4s
󰁹 97% at 22:06:49 ➜ systemd-run -pPrivateTmp=true -pDynamicUser=true -pSystemCallFilter=@system-service -pSystemCallFilter=~@privileged -pSystemCallFilter=~@resources -pExecStartPre="+bash -c 'echo \$UID'" -pPrivateUsers=true -t bash -c "ls"
Running as unit: run-u1241.service
Press ^] three times within 1s to disconnect TTY.
0
^C%
  </pre>
</details>

<!--
  }}}
-->

So now, we are left with the only option, which is to create a non-ephemeral user, assign it to the unit and disable DynamicUser.
This step is a little involved, you will have to add a user option to the service and forcibly disable DynamicUser.

I opted to replace the entire module file with my own under a different name, as I had to fix a mistake in it anyways.
Here's the link to [the modified source file.](https://github.com/soopyc/mystia/blob/a999736/modules/fixups/nitter.nix)
For clarity's sake, [this is the diff of the changes made.](https://github.com/soopyc/mystia/compare/3be5eef..a999736)

## what the hell is an IFD??
IFD stands for import from derivation.

*nixos/nixpkgs really need better and significantly less scattered documentation while improving manual readability.*

# Common pitfalls
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
> — \@getchoo

# Useful links

Builtin stdlib functions search engine: https://noogle.dev/


<!--links-->
[nixpkgs:lib/modules.nix#122]: https://github.com/NixOS/nixpkgs/blob/6e68daefde56a7a8e6fe7c3ca9ceeb436294bb9f/lib/modules.nix#L122
[nixpkgs:nixos/lib/eval-config.nix]: https://github.com/NixOS/nixpkgs/blob/5054472759a3b0df8e18cfe4031a5eff92d4cdc3/nixos/lib/eval-config.nix
