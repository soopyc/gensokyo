{ pkgs, ...}: {
  services.kanidm = {
    enableClient = true;
    package = pkgs.kanidm_1_7;
    clientSettings = {
      uri = "https://serenity.mist-nessie.ts.net";
    };
  };
}
