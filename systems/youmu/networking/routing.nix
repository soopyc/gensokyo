{ pkgs, lib, ... }:
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
        set wan_ip {
          type ipv4_addr;
        }

        chain prerouting {
          type nat hook prerouting priority dstnat; policy accept;

          # koumakan essentials
          iif "${wanIf}" tcp dport { 22, 80, 443 } dnat to 10.69.2.16
          iif "${wanIf}" udp dport 443 dnat to 10.69.2.16

          # minecraft
          iif "${wanIf}" tcp dport 25565-25599 dnat to 10.69.2.16

          # partially thanks to https://www.monotux.tech/posts/2024/04/hairpin-nat-nftables/
          ip saddr 10.69.0.0/16 ip daddr @wan_ip dnat to 10.69.2.16
        }
      '';
    };

    preCheckRuleset = ''
      sed '/iif "/s/${wanIf}/lo/g' -i ruleset.conf
    '';
  };

  # feels botched, but whatever lmao
  systemd = {
    timers."nft-update-wanip" = {
      timerConfig = {
        OnUnitActiveSec = "30s";
      };

      wantedBy = lib.singleton "multi-user.target";
    };

    services."nft-update-wanip" = {
      path = with pkgs; [
        jq
        iproute2
        nftables
      ];
      script = ''
        set -euo pipefail

        IP_ADDR=$(ip --json a show ${wanIf} \
          | jq '.[0].addr_info | map(select(.family == "inet"))[0] | .local' --raw-output)

        nft \
          flush set ip gensokyo-nat wan_ip\; \
          add element ip gensokyo-nat wan_ip "{ $IP_ADDR }"
      '';

      after = lib.singleton "network-online.target";
      requires = lib.singleton "network-online.target";
    };
  };
}
