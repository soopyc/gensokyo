{pkgs, ...}: {
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

      # extraConfig = {
      #   pipewire = {
      #     "10-force-quantum" = {
      #       "context.properties" = {
      #         "default.clock.quantum" = 2048;
      #         "default.clock.min-quantum" = 1024;
      #         "default.clock.quantum-floor" = 1024;
      #       };
      #     };
      #   };

      #   pipewire-pulse = {
      #     "stream.properties" = {
      #       "node.latency" = "256/48000";
      #     };
      #   };
      # };

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
  # systemd.user.services.pipewire-pulse = {};
}
