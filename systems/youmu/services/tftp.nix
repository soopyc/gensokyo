{ pkgs, ... }:
{
  # TODO: fix firewall
  systemd.tmpfiles.settings."50-netboot-xyz-files" = {
    "/srv/tftp".d.mode = "0755";
    "/srv/tftp/netbootxyz.amd64.efi"."L+".argument = "${pkgs.netbootxyz-efi}";
  };

  services.atftpd.enable = true;
}
