# `_utils.mkNginxFile`
`{filename<str> ? "index.html", content<str>, status<int> ? 200} -> {alias<str>, tryFiles<str>}`

Helper function to generate an attrset compatible with a nginx vhost `locations` attribute that serves a single file.

## Example

### Without filename
```nix
services.nginx.virtualHosts."example.com".locations."/" = _utils.mkNginxFile {
  content = ''
    <!doctype html><html><body>We've been trying to reach you about your car's Extended Warranty.</body></html>
  '';
};
```

### With filename
```nix
services.nginx.virtualHosts."filename.example.com".locations."/filename" = _utils.mkNginxFile {
  content = "the filename doesn't really matter, but it's there to help you figure out where your things are";
  filename = "random.txt";
}
```
