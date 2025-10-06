{
  lib,
  config,
  ...
}:
lib.mkIf config.gensokyo.traits.gui {
  services.logind = {
    # settings.Login = {
    #   KillUserProcesses = false;
    #   HandleSuspendKey = "lock";
    #   HandleHibernateKey = "lock";
    #   HandleLidSwitch = "lock";
    #   IdleAction = "lock";
    # };
  };

  # hopefully eradicate buggy shid
  systemd.targets =
    lib.genAttrs
      [
        # "sleep"
        # "suspend"
        "hibernate"
        "hybrid-sleep"
      ]
      (_: {
        enable = false;
      });
}
