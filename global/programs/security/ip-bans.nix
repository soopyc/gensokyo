{ lib, ... }:
let
  banned = {
    ip = [
      "156.229.232.142" # added 2025-04-10: minecraft server scanner with 30m intervals
    ];
    ip6 = [ ];
  };
in
{
  networking.firewall.extraCommands = builtins.concatStringsSep "\n" (
    lib.flatten (
      lib.mapAttrsToList (
        family: ips: builtins.map (ip: "${family}tables -w -I INPUT -s ${ip} -j DROP") ips
      ) banned
    )
  );
}
