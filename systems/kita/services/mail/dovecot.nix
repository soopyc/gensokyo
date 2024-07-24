{
  config,
  pkgs,
  ...
}: {
  # IMPORTANT: needed for ssh_dh in dovecot.
  security.dhparams = {
    enable = true;
    params.dovecot2 = {};
  };

  services.dovecot2 = {
    enable = true;

    createMailUser = true;
    mailUser = "vmail";
    mailGroup = "vmail";

    # we ignore nixos options and do our own config because order matters.
    configFile = pkgs.writeText "dovecot.conf" ''
      # ssl config
      ssl = required
      disable_plaintext_auth = yes
      ssl_cert = <${config.security.acme.certs."kita.c.soopy.moe".directory + "/full.pem"}
      ssl_key = <${config.security.acme.certs."kita.c.soopy.moe".directory + "/full.pem"}
      ssl_dh = <${config.security.dhparams.params.dovecot2.path}
      ssl_min_protocol = TLSv1.2
      # default ssl cipher list without non ec deffie-hellman algos
      ssl_cipher_list = ALL:!DH:!kRSA:!SRP:!kDHd:!DSS:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!PSK:!RC4:!ADH:!LOW@STRENGTH

      # default configurations
      base_dir = /run/dovecot2
      maildir_copy_with_hardlinks = yes
      sendmail_path = /run/wrappers/bin/sendmail
      default_internal_user = dovecot2  # nixos weirdness
      default_internal_group = dovecot2  # nixos weirdness

      # namespaces (mailboxes)
      # see dovecot/doc/example-config/conf.d/{10-mail,15-mailboxes}.conf for details
      namespace inbox {
        type = private
        inbox = yes
        list = yes

        # special mailboxes
        mailbox Drafts {
          special_use = \Drafts
          auto = create
        }
        mailbox Junk {
          special_use = \Junk
          auto = create
        }
        mailbox Trash {
          special_use = \Trash
          auto = create
        }
        mailbox Sent {
          special_use = \Sent
          auto = create
        }
      }
    '';
  };

  networking.firewall.allowedTCPPorts = [
    993 # imaps
  ];
}
