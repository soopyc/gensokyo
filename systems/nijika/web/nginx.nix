{
  services.nginx = {
    enable = true;
    enableReload = true;

    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedBrotliSettings = true;
    # TODO: wipe _utils.mkVhost and gensokyo.presets.nginx, replace with gensokyo.nginx
  };
}
