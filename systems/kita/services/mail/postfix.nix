{config, ...}: let
  cfg = config.services.postfix;
  queueDir = "/var/lib/postfix/queue";
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
      queue_directory = queueDir;

      # smtpd security
      smtpd_tls_chain_files = config.security.acme.certs."kita.c.soopy.moe".directory + "/full.pem";
      smtpd_tls_security_level = "may"; # RFC 2487 and 3207 tells me I shouldn't reject mail without STARTTLS.
      smtpd_tls_auth_only = true;
      smtpd_tls_mandatory_ciphers = "high";
      smtpd_tls_mandatory_protocols = ">=TLSv1.2";
      # smtp security
      smtp_tls_protocols = ">=TLSv1.2";
      smtp_tls_security_level = "dane";
      smtp_dns_support_level = "dnssec";

      # front-line spam protection
      disable_vrfy_command = true;
      smtpd_helo_required = true;
      smtpd_client_restrictions = [
        "reject_unknown_client_hostname"
        "permit_dnswl_client list.dnswl.org"
        # "reject_rbl_client zen.spamhaus.org=127.0.[0..2].[0..255]" # this also bans our own main server - blame linode
        "reject_rbl_client all.spamrats.com=127.0.0.[36..38]"
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
      smtpd_recipient_restrictions = [
        "reject_unknown_recipient_domain"
        "reject_unverified_recipient" # dovecot lmtp check, requires dovecot
      ];

      # dovecot integration with lmtp
      virtual_transport = "lmtp:unix:${queueDir}/dovecot-lmtp";
      virtual_mailbox_domains = [
        "soopy.moe"
        "services.soopy.moe"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [
    25 # smtp
    465 # submissions (secure)
    # 587 # submission (starttls)
  ];
}
