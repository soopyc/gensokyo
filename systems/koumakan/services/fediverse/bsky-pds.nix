{
  inputs,
  pkgs,
  ...
}: {
  services.bsky-pds = {
    enable = true;
    package = inputs.mystia.packages.${pkgs.system}.bsky-pds;
    settings.PDS_HOSTNAME = "bsky.soopy.moe";
  };
}
