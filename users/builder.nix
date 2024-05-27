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
        (inputs + "/creds/ssh/users/builder")
      ];
    };
    isNormalUser = false;
  };
}
