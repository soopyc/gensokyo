{...}: {
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

      extraConfig.pipewire = {
        "10-force-medium-quantum" = {
          "context.properties" = {
            "default.clock.quantum" = 1024;
            "default.clock.min-quantum" = 256;
            "default.clock.quantum-floor" = 256;
          };
        };
      };
    };
  };
}
