{
  lib,
  config,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  # hopefully eradicate suspend
  services.logind = {
    settings.Login = {
      KillUserProcesses = false;
      HandleSuspendKey = "lock";
      HandleHibernateKey = "lock";
      HandleLidSwitch = "lock";
      IdleAction = "lock";
    };
  };

  systemd.targets =
    lib.genAttrs
      [
        "sleep"
        "suspend"
        "hibernate"
        "hybrid-sleep"
      ]
      (_: {
        enable = false;
      });
}
