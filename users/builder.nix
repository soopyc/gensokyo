{
  inputs,
  config,
  lib,
  pkgs,
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

    # allow builders to actually access nix
    # todo: harden this somehow
    shell = pkgs.zsh;
  };
}
