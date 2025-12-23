{
  systemd.tmpfiles.settings."nginx-stream-log"."/var/log/nginx/stream"."d" = {
    user = "nginx";
    group = "nginx";
    mode = "0750";
  };
  systemd.services.nginx.serviceConfig = {
    # needed for transparent proxying
    CapabilityBoundingSet = ["CAP_NET_RAW"];
    AmbientCapabilities = ["CAP_NET_RAW"];
  };

  services.nginx.streamConfig = ''
    resolver 100.100.100.100;
    proxy_bind $remote_addr transparent;
    proxy_connect_timeout 1s;
    proxy_timeout 30s;

    log_format basic_stream '$remote_addr [$time_local] '
                            '$protocol $status $bytes_sent $bytes_received '
                            '$session_time';

    error_log /var/log/nginx/stream/error.log;
    access_log /var/log/nginx/stream/access.log basic_stream;

    # data
    server {
      listen 25565-25599 reuseport;
      proxy_pass renko.mist-nessie.ts.net:$server_port;
    }

    # query sockets
    server {
      listen 25565-25599 udp reuseport;
      proxy_pass renko.mist-nessie.ts.net:$server_port;
    }
    # voice
    server {
      listen 55111-55199 udp reuseport;
      proxy_pass renko.mist-nessie.ts.net:$server_port;
    }
  '';
}
