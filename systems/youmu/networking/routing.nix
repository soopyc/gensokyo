let
  # lanIf = "enp0s31f6";
  wanIf = "wan0";
in
{
  networking.nftables = {
    enable = true;

    tables."gensokyo-nat" = {
      family = "ip";
      content = ''
        chain prerouting {
          type nat hook prerouting priority dstnat; policy accept;

          # koumakan essentials
          iif "${wanIf}" tcp dport { 22, 80, 443 } dnat to 10.69.2.16
          iif "${wanIf}" udp dport 443 dnat to 10.69.2.16

          # minecraft
          iif "${wanIf}" tcp dport 25565-25599 dnat to 10.69.2.16
        }
      '';
    };

    preCheckRuleset = ''
      sed '/iif "/s/${wanIf}/lo/g' -i ruleset.conf
    '';
  };
}
