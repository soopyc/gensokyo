{
  lib,
  config,
  ...
}:
lib.mkMerge [
  (lib.mkIf (!config.gensokyo.traits.sensitive) {
    security.pam = {
      rssh = {
        enable = true;
        # not released yet :moai:
        # settings.cue = true;
      };

      services.sudo.rssh = true;
    };
  })
]
