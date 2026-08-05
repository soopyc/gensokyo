{ pkgs, ... }:
{
  services.kanidm = {
    package = pkgs.kanidm_1_11;
    client = {
      enable = true;
      settings = {
        uri = "https://serenity.mist-nessie.ts.net";
      };
    };
  };
}
