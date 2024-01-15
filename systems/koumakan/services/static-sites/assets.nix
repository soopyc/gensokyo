{_utils, ...}: {
  services.nginx.virtualHosts."assets.soopy.moe" = _utils.mkVhost {
    root = "/opt/public-assets";
    locations = {
      "/".extraConfig = ''
        expires max;
        etag on;
        autoindex on;
        add_header Cache-Control "public";
      '';

      "~* /\\.(?!well-known)".extraConfig = ''
        deny all;
      '';
    };
  };
}
