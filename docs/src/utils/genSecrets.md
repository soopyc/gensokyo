# `_utils.genSecrets`
`namespace<str> -> files<list[str]> -> value<attrset> -> attrset`

```admonish danger
This function is now an internal function. The signature is not likely to be changed, but there are better utilities to
do the job even better. Consider using [`setupSecrets`](./setupSecrets.md) instead.
```

generate an attrset to be passed into sops.secrets.

## Example
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

See <https://github.com/soopyc/nix-on-koumakan/blob/b7983776143c15c91df69ef34ba4264a22047ec6/systems/koumakan/services/fedivese/akkoma.nix#L8-L34> for a more extensive example
