{...}: {
  virtualisation.vmVariant.users.users._tester = builtins.warn "[vm] building tester user..." {
    password = "explode";
    isNormalUser = true;
    extraGroups = ["wheel"];
  };
}
