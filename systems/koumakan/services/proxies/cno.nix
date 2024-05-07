# reverse proxy to cache.nixos.org for services with utter terrible routes.
# password is there to slow down spam - we're not an open proxy.
{_utils, pkgs, lib, ...}: {
  services.nginx.virtualHosts."nixpkgs.reverse.proxy.internal.soopy.moe" = _utils.mkVhost {
    locations."/" = {
      useACMEHost = "proxy.c.soopy.moe";
      proxyPass = "https://cache.nixos.org";

      basicAuthFile = pkgs.writeText "nixpkgs-proxy-auth" ''
        balls:$5$.NQ3wV7LOGMoBfio$W5hWgQqz58HkYZefBB45bBVU6lGYDKmuOKZmTY1Ypx/
      '';
    };

    extraConfig = lib.mkForce ''
      # store access logs and see who's accessing the proxy, then ban them.
      access_log /var/log/nginx/cno.access;
      error_log /var/log/nginx/error.log crit;
    '';
  };
}
