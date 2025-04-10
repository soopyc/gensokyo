{ lib, ... }:
{
  services.postgresql = {
    enable = true;
    enableTCPIP = true;

    authentication = lib.mkForce ''
      local all all              peer
      host  all all 127.0.0.1/32 scram-sha-256
      host  all all ::1/128      scram-sha-256
    '';
  };
}
