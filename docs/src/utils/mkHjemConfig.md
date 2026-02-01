# `_utils.mkHjemConfig`
`user<str> -> path<str> -> attr<attrset> -> attrset`

a simple shorthand function for a longwinded `hjem` config attribute:
`hjem.users.${user}.xdg.config.files.${path} = attr`

## Example
```nix
{ _utils, ... }:
{
  imports = [
    (_utils.mkHjemConfig "user" "git/config" {
      user.name = "someUser";
      # ...
    })
  ];
}
```
