{
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "me@soopy.moe";
      reloadServices = [ "nginx" ];
      profile = "shortlived";

      # i genuinely don't understand why they felt the need to have an offline mode *just* for validity checks
      # it's not like ACME can operate without working a working network, and systemd services are orderable.
      # why is depending on network-online.target and other stuff not viable?
      #
      # now i have to configure *2* things because they aren't connected...
      # ...though it doesn't _necessitate_ configuration, cuz the max lifetime of certs keep getting shorter.
      # still, i'm not convinced of the over-engineering. if i do come across a valid reason, i'll update this.
      # -soopyc (2026-05-21)
      # validMinDays = 3;

      extraLegoRenewFlags = [
        # "--renew-days 0" # added in v5, we're still stuck on v4
      ];
    };
  };
}

