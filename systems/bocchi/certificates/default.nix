{
  _utils,
  config,
  ...
}: let
  secrets = _utils.setupSecrets config {
    namespace = "lego";
    secrets = ["cf_token"];
  };
in {
  imports = [
    secrets.generate

    ./bocchi.nix
  ];

  security.acme = {
    defaults = {
      # == lego Configuration ==
      credentialFiles = {
        CLOUDFLARE_DNS_API_TOKEN_FILE = secrets.get "cf_token";
      };
      dnsProvider = "cloudflare";
      # In an ideal world we would have an ed/cv25519 algo here but oh well
      keyType = "ec256"; # Ensure we use ec keys

      # == LE Configuration ==
      email = "me@soopy.moe";
      # server = "https://acme-staging-v02.api.letsencrypt.org/directory";
      server = "https://acme-v02.api.letsencrypt.org/directory";
    };

    acceptTerms = true;
  };
}
