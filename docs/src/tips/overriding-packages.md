# Overriding Packages
The nix pill confused me and i thought i had to make overlays to do overrides but no

in packages (i.e. `environment.systemPackages`), just do
```nix
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (discord.override {withOpenASAR = true;})
  ];
}
```

This works as well
```nix
security.sudo.package = (pkgs.sudo.override {withInsults = true;});
```
