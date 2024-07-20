{
  _utils,
  config,
  lib,
  ...
}: let
  secrets = _utils.setupSecrets config {
    namespace = "lego";
    secrets = ["cf_token"];
  };
in {
  config = lib.mkIf config.gensokyo.presets.certificates (lib.mkMerge [
    {
      security.acme = {
        acceptTerms = true;

        defaults = {
          # == lego Configuration ==
          # In an ideal world we would have an ed/cv25519 algo here but oh well
          keyType = "ec256"; # Ensure we use ec keys
          credentialFiles.CLOUDFLARE_DNS_API_TOKEN_FILE = secrets.get "cf_token";
          dnsProvider = "cloudflare";

          # == LE Configuration ==
          email = "me@soopy.moe";
          # server = "https://acme-staging-v02.api.letsencrypt.org/directory";
          server = "https://acme-v02.api.letsencrypt.org/directory";
        };
      };
    }
    secrets.generate
  ]);
}
