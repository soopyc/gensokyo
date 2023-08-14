{ ... }: 

{
  security.acme = {
    defaults = {
      # == lego Configuration ==
      # We use desec.io, so use those here
      credentialsFile = "/etc/lego/creds";
      dnsProvider = "desec";
      # In an more ideal world we would have an eddsa algo here but oh well
      keyType = "ec256";  # Ensure we use ec keys
  
      # == LE Configuration ==
      email = "me@soopy.moe";
      # TODO: toggle these 2 after testing
      server = "https://acme-staging-v02.api.letsencrypt.org/directory";
      #server = "https://acme-v02.api.letsencrypt.org/directory";
    };

    acceptTerms = true;
  };

  # TODO: Remove after testing.
  security.acme.certs."3b036246-d40d-483b-a9e6-2b6850a611ee.staging.soopy.moe" = {};
}
