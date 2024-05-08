# we could make this into a presets system
{...}: {
  services.nginx = {
    enable = true;
    enableReload = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    clientMaxBodySize = "5m";
  };
}
