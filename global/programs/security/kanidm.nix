{ pkgs, ... }:
{
  services.kanidm = {
    enableClient = true;
    package = pkgs.kanidm_1_9;
    clientSettings = {
      uri = "https://serenity.mist-nessie.ts.net";
    };
  };
}
