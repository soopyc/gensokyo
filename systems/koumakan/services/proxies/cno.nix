# reverse proxy to cache.nixos.org for services with utter terrible routes.
# password is there to slow down spam - we're not an open proxy.
{
  _utils,
  pkgs,
  lib,
  ...
}: {
  services.nginx.virtualHosts."nixpkgs.reverse.proxy.internal.soopy.moe" = _utils.mkVhost {
    locations."/" = {
      proxyPass = "https://cache.nixos.org/";
      recommendedProxySettings = false;

      basicAuthFile = pkgs.writeText "nixpkgs-proxy-auth" ''
        balls:$2y$05$97UTo7JHuyWNS7UeFdiTvuwxZkG0XXO9XklD5TmUKWrL5iMaH5Gq6
      '';

      extraConfig = ''
        proxy_set_header Host cache.nixos.org;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        proxy_ssl_session_reuse on;
        proxy_ssl_server_name on;
        proxy_ssl_protocols TLSv1.2 TLSv1.3;
      '';
    };

    useACMEHost = "proxy.c.soopy.moe";
    extraConfig = lib.mkForce ''
      # store access logs and see who's accessing the proxy, then ban them.
      access_log /var/log/nginx/cno.log;
      error_log /var/log/nginx/cno.log crit;
    '';
  };
}
