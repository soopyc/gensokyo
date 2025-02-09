# Certificates presets

```nix
{...}: {
  gensokyo.presets.buildbot = true;
}
```

This enables the buildbot worker on the current host.

This requires the following secrets to be set:

```yaml
buildbot:
    token: # generate from cloudflare
```
