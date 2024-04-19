{...}: {
  services.grafana.provision = {
    datasources.settings = {
      apiVersion = 1; # i am stupid. keep this as 1.

      datasources = [
        {
          version = 2;
          name = "panopticon";
          type = "prometheus";
          uid = "gs_panopticon";
          url = "http://localhost:20090";
          isDefault = true;
          jsonData = {prometheusVersion = "2.44.0";};
        }
      ];
    };

    dashboards.settings = {
      apiVersion = 1; # same as above

      providers = [
        {
          name = "flake";
          allowUiUpdates = false;
          options.path = ./dashboards;
        }
      ];
    };
  };
}
