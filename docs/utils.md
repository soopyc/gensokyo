# utility functions

## `_utils.mkVhost`
`attrset -> attrset`
make a virtual host with sensible defaults

pass in a set to override the defaults.

### Example
```nix
services.nginx.virtualHosts."balls.example" = _utils.mkVhost {};
```

## `_utils.mkSimpleProxy`
`attrset -> attrset`

make a simple reverse proxy

takes a set:
```nix
{
  port,
  protocol ? "http",
  location ? "/",
  websockets ? false,
  extraConfig ? {}
}
```

It is recommended to override/add attributes with `extraConfig` to
preserve defaults.

Items in `extraConfig` are merged verbatim to the base attrset with defaults.
They are overridden based on their order.

## `_utils.genSecrets`
`namespace<str> -> files<list[str]> -> value<attrset> -> attrset`

generate an attrset to be passed into sops.secrets.

### Example
```nix
{ _utils, ... }:
let
  secrets = [
    "secure_secret"
    # this is a directory structure, so secrets will be stored as a file in /run/secrets/service/test/secret.
    "service/test/secret"
  ];
in {
  sops.secrets = _utils.genSecrets "" secrets {}; # it's recommended to use a namespace, but having none is still fine.
  # -> sops.secrets."secure_secret" = {};
  #    sops.secrets."service/test/secret" = {};
  sops.secrets = _utils.genSecrets "balls" ["balls_secret"] {owner = "balls";};
  # -> sops.secrets."balls/balls_secret" = {owner = "balls";};
}
```

See https://github.com/soopyc/nix-on-koumakan/blob/b7983776143c15c91df69ef34ba4264a22047ec6/systems/koumakan/services/fedivese/akkoma.nix#L8-L34 for a more extensive example

## `_utils.mkNginxFile`
`filename<str> -> contents<str> ==> ` *derivation*

Simple file derivation generator to use with nginx aliases.

### Example
```nix
services.nginx.virtualHosts."example.com".locations."/" = {
  alias = _utils.mkNginxFile "index.html" ''
  <!doctype html><html><body>We've been trying to reach you about your car's Extended Warranty.</body></html>
  '';
  tryFiles = "index.html =404";
};
```

## `_utils.mkNginxJSON`
`filename<str> -> attrset ==>` *derivation*

Simple wrapper around `_utils.mkNginxFile` that takes in an attrset and formats it as JSON.
