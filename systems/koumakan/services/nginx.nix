{ pkgs, ... }:
{
  gensokyo.presets.nginx = true;

  users.users.nginx.extraGroups = [ "anubis" ];
  services.nginx = {
    enable = true;
    clientMaxBodySize = "50m";

    additionalModules = with pkgs.nginxModules; [
      fancyindex
      brotli
    ];
  };

  # necessary for stuff like backup-public.nix and user.nix
  systemd.services.nginx.serviceConfig.ProtectHome = "tmpfs";
}
