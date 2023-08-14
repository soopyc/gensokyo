{ pkgs, ... }:

{
  services.nginx = {
    enable = true;
    enableReload = true;
    package = pkgs.nginxMainline;

    statusPage = true;
  };
}
