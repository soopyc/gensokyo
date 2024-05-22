# reverse proxy to hydra.soopy.moe.
{_utils, ...}: {
  services.nginx.virtualHosts."cache.soopy.moe" = _utils.mkVhost {
    locations."/" = {
      proxyPass = "https://hydra.soopy.moe/";
      recommendedProxySettings = false;

      extraConfig = ''
        proxy_set_header Host hydra.soopy.moe;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        proxy_ssl_session_reuse on;
        proxy_ssl_server_name on;
        proxy_ssl_protocols TLSv1.2 TLSv1.3;
      '';
    };
  };
}
