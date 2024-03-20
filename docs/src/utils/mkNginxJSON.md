# `_utils.mkNginxJSON`
`filename<str> -> freeformAttrset ==> attrset`

Simple wrapper around [`mkNginxFile`](./mkNginxFile.md) that takes in an attrset and formats it as JSON.

Note that the function signature is different in that it doesn't take in only one attrset.
This may change in the future.

## Example
```nix
services.nginx.virtualHosts."balls.org" = _utils.mkVhost {
  locations."/" = _utils.mkNginxJSON "index.json" {
    arbitraryAttribute = "arbitraryValue";
    doTheyKnow = false;
  };
};
```

<!-- TODO: check if Content-Type is correctly returned with this -->
