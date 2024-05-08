{pkgs, ...}: {
  gensokyo.presets.nginx = true;

  services.nginx = {
    enable = true;
    clientMaxBodySize = "50m";

    additionalModules = with pkgs.nginxModules; [
      fancyindex
      brotli
    ];
  };
}
