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

    enableSmtp = true; # TODO: disable when using postscreen.
    enableSubmission = false;
    enableSubmissions = true;

    config = {
      # security
      smtpd_tls_chain_files = config.security.acme.certs."kita.c.soopy.moe".directory + "/full.pem";
      smtpd_tls_security_level = "may"; # RFC 2487 and 3207 tells me I shouldn't reject mail without STARTTLS.
      smtpd_tls_auth_only = true;
      smtpd_tls_mandatory_ciphers = "high";
      smtpd_tls_mandatory_protocols = ">=TLSv1.2";

      smtp_tls_protocols = ">=TLSv1.2";
      smtp_tls_security_level = "dane";
      smtp_dns_support_level = "dnssec";

      # front-line spam protection
      disable_vrfy_command = true;
      smtpd_helo_required = true;
      smtpd_client_restrictions = [
        "reject_unknown_client_hostname"
        "reject_rbl_client zen.spamhaus.org=127.0.[0..2].[0..255]" # TODO: maybe move to postscreen
        "permit_dnswl_client list.dnswl.org" # TODO: move to postscreen
      ];
      smtpd_helo_restrictions = [
        # postscreen doesn't handle HELO stuff.
        "reject_unknown_helo_hostname"
        "reject_non_fqdn_helo_hostname"
      ];
      smtpd_relay_restrictions = [
        "permit_sasl_authenticated"
        "reject_unauth_destination"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [
    25 # smtp
    465 # submissions (secure)
    # 587 # submission (starttls)
  ];

  # stupid fucking cunt
  nixpkgs.overlays = [
    (_: prev: {
      postfix = prev.postfix.override {withPgSQL = true;};
    })
  ];
}
