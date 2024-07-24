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

    createMailUser = false; # we'll handle that
    mailUser = config.users.users.vmail.name;
    mailGroup = config.users.groups.vmail.name;

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
      default_internal_user = dovecot2  # nixos weirdness
      default_internal_group = dovecot2  # nixos weirdness
      sendmail_path = /run/wrappers/bin/sendmail

      # maildir configs location
      mail_location = maildir:~/Mail
      maildir_copy_with_hardlinks = yes

      # namespaces (mailboxes)
      # see dovecot/doc/example-config/conf.d/{10-mail,15-mailboxes}.conf for details
      namespace inbox {
        type = private
        inbox = yes
        list = yes

        # special mailboxes
        mailbox Drafts {
          special_use = \Drafts
          auto = subscribe
        }
        mailbox Junk {
          special_use = \Junk
          auto = subscribe
        }
        mailbox Trash {
          special_use = \Trash
          auto = subscribe
        }
        mailbox Sent {
          special_use = \Sent
          auto = subscribe
        }
      }
    '';
  };

  users.users.vmail = {
    uid = 3000;
    description = "Virtual Mail User";
    group = config.users.groups.vmail.name;
    isSystemUser = true;
    home = "/var/vmail";
    createHome = true;
  };
  users.groups.vmail.gid = 3000;

  networking.firewall.allowedTCPPorts = [
    993 # imaps
  ];
}
