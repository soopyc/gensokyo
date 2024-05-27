{
  inputs,
  config,
  lib,
  ...
}:
lib.mkIf (!config.gensokyo.traits.sensitive) {
  users.users.builder = {
    openssh = {
      authorizedKeys.keyFiles = [
        (inputs.self + "/creds/ssh/users/builder")
      ];
    };
    isNormalUser = false;
    isSystemUser = true;
    group = "nixbld";
  };
}
