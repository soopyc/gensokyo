{config, ...}: let
  cfg = config.services.postfix;
in {
  services.postfix = {
    enable = true;
    domain = "soopy.moe";
    hostname = "mx2.soopy.moe";
    origin = "mx2.soopy.moe";
    destination = [
      "localhost"
      "localhost.localdomain"
      cfg.hostname
      "staging.soopy.moe" # TODO: remove after testing
      # don't put soopy.moe here, that goes into virtual stuff.
    ];

    # leave relayHost to be "".
    relayDomains = [];
    networksStyle = "host";

    postmasterAlias = "cassie";
    rootAlias = "cassie";
  };

  networking.firewall.allowedTCPPorts = [
    25 # smtp
    465 # submissions (secure)
    # 587 # submission (starttls)
  ];
}
