# Certificates presets

```nix
{...}: {
  gensokyo.presets.certificates = true;
}
```

This enables and set some ACME related configurations to a common value.

This requires the following secrets to be set:

```yaml
lego:
    cf_token: # generate from cloudflare
```
