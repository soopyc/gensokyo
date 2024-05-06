# from https://github.com/NixOS/nixpkgs/blob/e9be42459999a253a9f92559b1f5b72e1b44c13d/nixos/modules/services/security/yubikey-agent.nix
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.yubikey-agent-socket;
in {
  ###### interface

  meta.maintainers = with maintainers; [philandstuff rawkode jwoudenberg];

  options = {
    services.yubikey-agent-socket = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to start yubikey-agent when you log in.  Also sets
          SSH_AUTH_SOCK to point at yubikey-agent.

          Note that yubikey-agent will use whatever pinentry is
          specified in programs.gnupg.agent.pinentryPackage.
        '';
      };

      package = mkPackageOption pkgs "yubikey-agent" {};
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
    systemd.packages = [cfg.package];

    # This overrides the systemd user unit shipped with the
    # yubikey-agent package
    systemd.user.services.yubikey-agent = mkIf (config.programs.gnupg.agent.pinentryPackage != null) {
      path = [config.programs.gnupg.agent.pinentryPackage];
      # wantedBy = [ "default.target" ];
    };

    systemd.user.sockets.yubikey-agent = {
      wantedBy = ["sockets.target"];
      listenStreams = [
        "%t/yubikey-agent/yubikey-agent.sock"
      ];
    };

    # Yubikey-agent expects pcsd to be running in order to function.
    services.pcscd.enable = true;

    environment.extraInit = ''
      if [ -z "$SSH_AUTH_SOCK" -a -n "$XDG_RUNTIME_DIR" ]; then
        export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/yubikey-agent/yubikey-agent.sock"
      fi
    '';
  };
}
