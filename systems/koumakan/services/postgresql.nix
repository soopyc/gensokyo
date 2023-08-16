{ pkgs, ... }:

{
  services.postgresql = {
    enable = true;

    package = pkgs.postgresql_15;
    dataDir = "/var/lib/postgresql/15";
  };
}
