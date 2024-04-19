{
  lib,
  config,
  options,
  sopsDir,
  ...
}:
lib.mkIf (options.virtualisation ? qemu) {
  sops.secrets."passwords/_tester" = {
    sopsFile = sopsDir + "/../global/passwords.yaml";
    neededForUsers = true;
  };
  users.users._tester = builtins.trace "[vm] building tester user..." {
    hashedPasswordFile = config.sops.secrets."passwords/_tester".path;
    isNormalUser = true;
  };
}
