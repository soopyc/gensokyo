{ pkgs, ... }:
{
  services.nginx = {
    enable = true;
    enableReload = true;

    # needed for http/2 proxy_version
    package = pkgs.nginxMainline;

    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedBrotliSettings = true;
    # TODO: wipe _utils.mkVhost and gensokyo.presets.nginx, replace with gensokyo.nginx
  };
}
