{
  services.nginx.streamConfig = ''
    proxy_connect_timeout 1s;
    proxy_timeout 30s;

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
