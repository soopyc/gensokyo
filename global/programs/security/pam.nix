{
  lib,
  config,
  ...
}:
lib.mkMerge [
  (lib.mkIf (!config.gensokyo.traits.sensitive) {
    security.pam = {
      sshAgentAuth.enable = true;

      services.sudo.sshAgentAuth = true;
    };
  })
]
