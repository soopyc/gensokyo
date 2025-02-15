{
  lib,
  config,
  options,
  inputs,
  ...
}:
lib.mkIf (options.virtualisation ? qemu) {
  sops.secrets."passwords/_tester" = {
    sopsFile = inputs.self + "/creds/sops/global/passwords.yaml";
    neededForUsers = true;
  };
  users.users._tester = builtins.trace "[vm] building tester user..." {
    hashedPasswordFile = config.sops.secrets."passwords/_tester".path;
    isNormalUser = true;
  };
}
