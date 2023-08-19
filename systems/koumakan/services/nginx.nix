{ pkgs, ... }:

{
  services.nginx = {
    enable = true;
    enableReload = true;
    package = pkgs.nginxMainline;

    clientMaxBodySize = "50m";

    statusPage = true;

    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    additionalModules = with pkgs.nginxModules; [
      fancyindex
      brotli
    ];
  };
}
