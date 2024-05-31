{config, ...}: let
  nixos = config.system.nixos;
in {
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    # TODO: disable banner for service users like forgejo
    banner = ''
      -----BEGIN BANNER-----
      # Welcome to ${config.system.name}
      # ${nixos.distroName} ${nixos.codeName} (${nixos.label})
      i Trans rights are human rights

      ! You are currently accessing an internal resource. Your connection
      ! information, including but not limited to your authenticating IP address,
      ! username and the user you're attempting to log into are recorded.
      ! Disconnect IMMEDIATELY if you are not an authorized personnel.

      i Contact:
      i   [Matrix] @sophie:nue.soopy.moe
      i    [Email] me@soopy.moe
      ------END BANNER------
    '';
  };

  programs.ssh = {
    startAgent = true;
    pubkeyAcceptedKeyTypes = ["ssh-ed25519"];
    enableAskPassword = true;

    extraConfig = ''
      ConnectTimeout 5
    ''; # if things exceed 5 seconds to connect something has gone wrong. Fail fast to not wait.
  };
}
