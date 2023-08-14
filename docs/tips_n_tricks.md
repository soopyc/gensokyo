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

## nginx regex location
```nix
  locations."~ \.php$".extraConfig = ''
  # balls
  '';
```
from [nixos wiki](https://nixos.wiki/wiki/Nginx#LEMP_stack)
