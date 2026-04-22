{
  lib,
  config,
  ...
}:

lib.mkMerge [
  (lib.mkIf (!config.gensokyo.traits.sensitive) {
    boot.kernel.sysctl."kernel.sysrq" = 1;
  })
]
