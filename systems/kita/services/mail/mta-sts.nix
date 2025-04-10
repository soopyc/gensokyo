# mail-transfer-agent strict transport security policy
{ _utils, ... }:
{
  services.nginx.virtualHosts."mta-sts.soopy.moe" = _utils.mkVhost {
    useACMEHost = "kita-web.c.soopy.moe";

    locations."/.well-known/" = _utils.mkNginxFile {
      content = ''
        version: STSv1
        mode: enforce
        max_age: 604800
        mx: mx2.soopy.moe
      '';
      filename = "mta-sts.txt";
    };
  };
}
