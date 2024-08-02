{
  config,
  pkgs,
  ...
}: let
  postfixQueueDir = config.services.postfix.config.queue_directory;
in {
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

      # protocols
      protocols = imap lmtp
      auth_mechanisms = plain login # since we enforce ssl/tls we can safely use plain.

      # lmtp config w/ postfix
      service lmtp {
        unix_listener ${postfixQueueDir}/dovecot-lmtp {
          user = postfix
          group = postfix
          mode = 0600
        }
      }

      # user/password databases
      ## virtual first then pam, so we don't get pam errors
      ## virtual lookup
      passdb {
        driver = sql
        args = ${config.sops.templates."dovecot-sql.conf".path} # see bottom
      }

      ## pam/passwd lookup for local users
      passdb {
        driver = pam
        args = dovecot2 # to be consistent w/ upstream
      }

      # passwd first before static so static doesn't apply to passwd users (i think that's how it works)
      userdb {
        driver = passwd
        # https://doc.dovecot.org/configuration_manual/authentication/user_database_extra_fields/
        override_fields = mail=maildir:/var/mail/%u
        result_internalfail = return-fail
      }

      userdb {
        # for mail_location see above.
        driver = static
        args = uid=${builtins.toString config.users.users.vmail.uid} gid=${builtins.toString config.users.groups.vmail.gid} home=/var/vmail/%d/%n
        # no need to set maildir here again apparantly
      }

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
        mailbox Archive {
          special_use = \Archive
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

  sops.secrets."dovecot/db_password" = {};
  sops.templates."dovecot-sql.conf".content = ''
    driver = pgsql
    connect = host=localhost dbname=maildb user=maildb password=${config.sops.placeholder."dovecot/db_password"}

    password_query = SELECT username, domain, passwd AS password FROM users WHERE username = '%n' AND domain = '%d'
    # this doesn't work because we need a sql userdb for iterative queries
    #iterate_query = SELECT username, domain FROM users
    # user_query not needed since we handle that staticly with a template.
  '';

  networking.firewall.allowedTCPPorts = [
    993 # imaps
  ];

  # 最低
  nixpkgs.overlays = [
    (_: prev: {
      dovecot = prev.dovecot.override {withPgSQL = true;};
    })
  ];
}
