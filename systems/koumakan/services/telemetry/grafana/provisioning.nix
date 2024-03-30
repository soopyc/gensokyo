{...}: {
  services.grafana.provision = {
    datasources.settings = {
      # Note: Misleading config name: this does not define the (grafana) API version, just the config version.
      apiVersion = 1; # Increment this whenever anything else below is updated.

      datasources = [
        {
          name = "panopticon";
          type = "prometheus";
          uid = "gs_panopticon";
          jsonData = {prometheusVersion = "2.44.0";};
        }
      ];
    };

    dashboards.settings = {
      apiVersion = 1; # same as above

      providers = [{
        name = "flake";
        allowUiUpdates = false;
        options.path = ./dashboards;
      }];
    };
  };
}
