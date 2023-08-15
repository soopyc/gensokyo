{ ... }: 

{
  imports = [
    ./global.nix
    ./postgresql.nix
  ];

  security.acme = {
    defaults = {
      # == lego Configuration ==
      credentialsFile = "/etc/lego/desec";
      dnsProvider = "desec";
      # In an more ideal world we would have an eddsa algo here but oh well
      keyType = "ec256";  # Ensure we use ec keys
  
      # == LE Configuration ==
      email = "me@soopy.moe";
      # server = "https://acme-staging-v02.api.letsencrypt.org/directory";
      server = "https://acme-v02.api.letsencrypt.org/directory";
    };

    acceptTerms = true;
  };
}
