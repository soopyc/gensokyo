{...}: {
  environment.sessionVariables = {
    # wayland crap
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };
}
