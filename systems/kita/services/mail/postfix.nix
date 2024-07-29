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
      # smtpd security
      smtpd_tls_chain_files = config.security.acme.certs."kita.c.soopy.moe".directory + "/full.pem";
      smtpd_tls_security_level = "may"; # RFC 2487 and 3207 tells me I mustn't reject mail without encryption. Set to may to support opportunistic TLS.
      smtpd_tls_auth_only = true; # don't announce/accept SASL AUTH over plaintext/unencrypted channels
      smtpd_tls_mandatory_ciphers = "high";
      smtpd_tls_mandatory_protocols = ">=TLSv1.2";
      smtpd_tls_received_header = "yes"; # add TLS related headers to the Postfix Received: header
      # smtp security
      smtp_tls_protocols = ">=TLSv1.2";
      smtp_tls_security_level = "dane"; # fallbacks to may. would be great if this could give me a notification
      smtp_dns_support_level = "dnssec"; # enable dnssec lookups

      # fuckup remediation
      smtpd_reject_footer = "\c; If not intended, please contact the postmaster with methods listed in https://soopy.moe/about with the following data: client=$client_address, server=$server_name}";

      # front-line spam protection
      disable_vrfy_command = true;
      smtpd_helo_required = true;
      # Pre-everything checks
      smtpd_client_restrictions = [
        "reject_unknown_client_hostname" # reject clients with unmatching PTR records
        "permit_dnswl_client list.dnswl.org" # allowlist clients in the dnswl list to communicate
        "reject_rbl_client all.spamrats.com=127.0.0.[36..38]" # reject clients in the spamrats lists
      ];
      # HELO/EHLO command checks
      smtpd_helo_restrictions = [
        # postscreen shouldn't handle HELO stuff.
        "reject_unknown_helo_hostname" # reject clients that sends HELO with domain without an MX/A record
        "reject_non_fqdn_helo_hostname" # self-explanatory
      ];
      # MAIL FROM command checks
      smtpd_sender_restrictions = [
        "reject_non_fqdn_sender" # self-explanatory
        "reject_unknown_sender_domain" # reject if mail from domain has invalid mx records
      ];
      # I don't know how different these 2 are
      # RCPT TO command checks (relay policy)
      smtpd_relay_restrictions = [
        # "permit_sasl_authenticated" # handled under masterConfig.submissions
        "reject_unauth_destination"
      ];
      # RCPT TO command checks (spam policy)
      smtpd_recipient_restrictions = [
        "reject_unknown_recipient_domain"
        "reject_unverified_recipient" # FIXME: move back to a postgresql query method since this doesn't work well
      ];

      # Message filtering done at rspamd, milters added via NixOS module.

      # dovecot integration with lmtp
      virtual_transport = "lmtp:unix:dovecot-lmtp"; # we placed the socket in the queue directory and this is resolved from that dir.
      virtual_mailbox_domains = [
        "soopy.moe"
        "services.soopy.moe"
      ];
    };

    virtual = ''
      # catchall
      @soopy.moe cassie@soopy.moe
    '';
  };

  networking.firewall.allowedTCPPorts = [
    25 # smtp
    465 # submissions (secure)
    # 587 # submission (starttls)
  ];
}
