{
  services.caddy = {
    enable = true;
  };

  gensokyo.caddy.config = ''
    # public files
    youmu.mist-nessie.ts.net {
      root /srv/www
      file_server browse
    }
  '';

  systemd.tmpfiles.settings."10-www-directory"."/srv/www/".D = {
    mode = "0555";
  };
}
