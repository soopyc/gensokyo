# `_utils.mkSimpleProxy`
`{port, protocol, location, websockets, extraConfig} -> freeformAttrset`

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
They are overridden based on their priority order (i.e. via `lib.mk{Default,Force,Order}`).
