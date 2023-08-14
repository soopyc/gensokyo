{ pkgs, ... }:

{
  services.nginx = {
    enable = true;
    enableReload = true;
    package = pkgs.nginxMainline;

    statusPage = true;

    recommendedTlsSettings = true;
    additionalModules = with pkgs.nginxModules; [
      fancyindex
      brotli
    ];
  };
}
