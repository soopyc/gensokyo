# VictoriaMetrics presets

```nix
{...}: {
  gensokyo.presets.vmetrics = true;
}
```

This enables vmetrics and some default configurations. Afterwards, you can add new scrape configs like below.

```nix
{...}: {
  services.vmagent.prometheusConfig.scrape_configs = [{
    job_name = "nginx";
    static_configs = [{targets = ["localhost:${builtins.toString config.services.prometheus.exporters.nginx.port}"];}];
    relabel_configs = [{
      target_label = "instance";
      replacement = "${config.networking.fqdnOrHostName}";
    }];
  }];
}
```

## Prerequisites

You need to do the following things when adding a new host.

### Secrets

Include the follow secret configuration.

```yaml
vmetrics:
    auth: # openssl rand 129 | base64 -w0 | tr "/=+" "-_."
```

Then add to koumakan.
