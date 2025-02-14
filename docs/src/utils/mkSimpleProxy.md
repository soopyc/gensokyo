# `_utils.mkSimpleProxy`
`attrSet -> freeformAttrset`

make a simple reverse proxy

takes a set:
```nix
{
  host ? "localhost", # proxying servers on the network
  port ? null,
  socketPath ? null,
  protocol ? "http",
  location ? "/",
  websockets ? false,
  extraConfig ? {}
}
```

Provide either a `socketPath` to a UNIX socket or a `port` to connect to the upstream via TCP.
Note that both of these options are mutually exclusive in that only one can be specified.

It is recommended to override/add attributes with `extraConfig` to
preserve defaults.

Items in `extraConfig` are merged verbatim to the base attrset with defaults.
They are overridden based on their priority order (i.e. via `lib.mk{Default,Force,Order}`).
