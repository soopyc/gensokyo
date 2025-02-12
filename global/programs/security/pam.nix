{
  lib,
  config,
  ...
}:
lib.mkMerge [
  (lib.mkIf (!config.gensokyo.traits.sensitive) {
    security.pam = {
      rssh.enable = true;

      services.sudo.rssh = true;
    };
  })
]
