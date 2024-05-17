{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  services = {
    pipewire = {
      enable = true;

      audio.enable = true;
      jack.enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };

      wireplumber.configPackages = [
        # why aren't these consistent
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/50-disable-alsa-suspend.conf" ''
          monitor.alsa.rules = [{
            matches = [{node.name = "~alsa_output.*"}]
            actions = {
              update-props = {session.suspend-timeout-seconds = 0}
            }
          }]
        '')
      ];
    };
  };
  security.rtkit.enable = true;
}
