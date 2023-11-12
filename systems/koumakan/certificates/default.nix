{...}: {
  imports = [
    ./global.nix
    ./postgresql.nix
    ./fediverse.nix
    ./proxy.nix
  ];

  security.acme = {
    defaults = {
      # == lego Configuration ==
      credentialsFile = "/etc/lego/desec";
      dnsProvider = "desec";
      # In a more ideal world we would have an eddsa algo here but oh well
      keyType = "ec256"; # Ensure we use ec keys

      dnsResolver = "8.8.8.8:53";

      # == LE Configuration ==
      email = "me@soopy.moe";
      # server = "https://acme-staging-v02.api.letsencrypt.org/directory";
      server = "https://acme-v02.api.letsencrypt.org/directory";
    };

    acceptTerms = true;
  };
}
