{
  lib,
  config,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  # hopefully eradicate suspend
  services.logind = {
    suspendKey = "lock";
    extraConfig = ''
      IdleAction=lock
    '';
    killUserProcesses = true;
  };

  systemd.targets = lib.genAttrs [
    "sleep"
    "suspend"
    "hibernate"
    "hybrid-sleep"
  ] (_: {enable = false;});
}
