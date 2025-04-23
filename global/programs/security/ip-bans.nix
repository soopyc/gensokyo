{ lib, ... }:
let
  banned = {
    ip = [
      "156.229.232.142" # added 2025-04-10: minecraft server scanner with 30m intervals
      "156.146.63.199" # added 2025-04-11: minecraft server scanner, found no contact methods
    ];
    ip6 = [ ];
  };
in
{
  networking.firewall.extraCommands = builtins.concatStringsSep "\n" (
    [
      # i'd be damned if they rename the helper, but i also cba writing it *again*, for the same util to show up
      # 3 times in the final script.
      "ip46tables -N gensokyo-blackhole"
      "ip46tables -I INPUT -j gensokyo-blackhole"
    ]
    ++ lib.flatten (
      lib.mapAttrsToList (
        family: ips: builtins.map (ip: "${family}tables -w -I gensokyo-blackhole -s ${ip} -j DROP") ips
      ) banned
    )
  );

  networking.firewall.extraStopCommands = ''
    ip46tables -D INPUT -j gensokyo-blackhole || true
    ip46tables -F gensokyo-blackhole || true
    ip46tables -X gensokyo-blackhole || true
  '';
}
