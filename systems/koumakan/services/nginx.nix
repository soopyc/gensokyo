{pkgs, ...}: {
  gensokyo.presets.nginx = true;

  users.users.nginx.extraGroups = ["anubis"];
  services.nginx = {
    enable = true;
    clientMaxBodySize = "50m";

    additionalModules = with pkgs.nginxModules; [
      fancyindex
      brotli
    ];
  };
}
