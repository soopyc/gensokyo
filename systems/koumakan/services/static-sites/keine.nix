{ ... }:
{
  services.nginx.virtualHosts."keine.soopy.moe" = {
    useACMEHost = "global.soopy.moe";
    addSSL = true;  # Don't force SSL on a mirror (implications TBD)

    root = "/srv/www/keine";
    locations = {
      "/".extraConfig = ''
        fancyindex_header "/theme/index_header.html";
      '';
      "/theme".alias = "/srv/www/misc/keine/theme";
      "/static".alias = "/srv/www/misc/keine/theme/static/";
    };

    extraConfig = ''
      fancyindex              on;
      fancyindex_header       "/theme/header.html";
      fancyindex_footer       "/theme/footer.html";
      fancyindex_show_path    off;
      fancyindex_name_length  255;
      fancyindex_exact_size   off;
      fancyindex_localtime    on;
    '';
  };
}
