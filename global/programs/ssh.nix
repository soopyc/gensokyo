{
  config,
  pkgs,
  lib,
  ...
}:
let
  nixos = config.system.nixos;
in
{
  gensokyo.ports.sshd = 22;
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    hostKeys = [
      {
        bits = 4096;
        path = "/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        type = "mldsa44-ed25519";
        path = "/etc/ssh/ssh_host_mldsa44_ed25519_key";
      }
    ];
    settings = {
      Port = config.gensokyo.ports.sshd;
      UseDns = true; # shows hostname on lastlog
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      PubkeyAcceptedAlgorithms = "sk-ssh-ed25519@openssh.com,ssh-ed25519,ssh-mldsa44-ed25519@openssh.com";
      Banner = toString (
        pkgs.writeText "openssl-banner" ''
          -----BEGIN BANNER-----
          # Welcome to ${config.system.name}
          # ${nixos.distroName} ${nixos.codeName} (${nixos.label})
          i Trans rights are human rights

          ! You are currently accessing an internal resource. Your connection
          ! information, including but not limited to your authenticating IP address,
          ! username and the user you're attempting to log into are recorded.
          ! Disconnect IMMEDIATELY if you are not part of the authorized personnel.

          i Contact:
          i   [Matrix] @sophie:nue.soopy.moe
          i    [Email] me@soopy.moe
          ------END BANNER------
        ''
      );
    };
  };

  programs.ssh = {
    startAgent = true;
    pubkeyAcceptedKeyTypes = [
      "ssh-ed25519"
      "sk-ssh-ed25519@openssh.com"
      "ssh-mldsa44-ed25519@openssh.com"
    ];
    # enableAskPassword = true;

    extraConfig = ''
      ConnectTimeout 5
    ''; # if things exceed 5 seconds to connect something has gone wrong. Fail fast to not wait.
  };

  # i did not consent to having this automatically enabled
  services.gnome.gcr-ssh-agent.enable = false;
}
