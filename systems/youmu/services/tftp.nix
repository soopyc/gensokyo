{ pkgs, ... }:
let
  netbootxyz-efi = pkgs.fetchurl {
    url = "https://github.com/netbootxyz/netboot.xyz/releases/download/3.0.0/netboot.xyz-arm64.efi";
    hash = "sha256-0i3mKD5t4z3YsvXyNIl0n/4D/pEzoz2meAmqhb+f/9A=";
  };
in
{
  systemd.tmpfiles.settings."50-netboot-xyz-files" = {
    "/srv/tftp".d.mode = "0755";
    "/srv/tftp/netbootxyz.amd64.efi"."L+".argument = "${netbootxyz-efi}";
  };

  services.atftpd.enable = true;
}
