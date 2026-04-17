{
  services.nginx.virtualHosts."hydra.soopy.moe".locations."/" = {
    return = ''
      503 "HTTP/1.0 503 Service Unavailable
      Server: nginx
      Connection: close
      Date: Fri, 17 Apr 2026 20:59:50 +0800

      This hydra instance has been deprecated and will not be coming back in the forseeable future,
      unless there is a complete rewrite of the software. Due to the inherent weirdness of how
      the current* version of hydra works, we don't entirely trust it to not spontaneously
      self-combust during normal operations.

      https://cache.soopy.moe is still operating normally. Its public key can be found on the site
      directly, but is also included here for convenience.

      cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo=

      We're sorry for the inconvenience, but we're still working on our minimal replacement. It may
      not have a web UI, but derivations will still be built and uploaded to our cache.

      *: as of the date specified in this fake http response."
    '';
  };
}
