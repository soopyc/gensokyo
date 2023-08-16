# utility functions

## `utils.mkVhost`
make virtual host with sensible defaults

pass in a set to override the defaults.

## `utils.mkSimpleProxy`
make a simple reverse proxy

takes a set:
```nix
{
  port,
  protocol ? "http",
  location ? "/",
  websockets ? false
}
```
