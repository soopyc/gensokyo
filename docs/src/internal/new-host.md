# Adding a new host

## Secret configuration

```yaml
vmetrics:
    auth: # openssl rand 129 | base64 -w0 | tr "/=+" "-_."
lego:
    cf_token: # generate from cloudflare
```
