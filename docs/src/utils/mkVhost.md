# `_utils.mkVhost`
`freeformAttrset -> freeformAttrset`

make a virtual host with sensible defaults.

pass in an attrset to override the defaults. the attrset is essentially the same as any virtual host config.

## Example
```nix
services.nginx.virtualHosts."balls.example" = _utils.mkVhost {};
```
