{ pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16; # we like to specify a package so we know what we're using.
    ensureUsers = [
      {
        name = "maildb";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [ "maildb" ];
  };
}
