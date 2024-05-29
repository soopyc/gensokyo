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
    # group = "nixbld";
    # https://github.com/NixOS/nix/blob/946fd29422361e8478425d6aaf9ccae23d7ddffb/src/nix/daemon.cc#L266-L267
    # https://discourse.nixos.org/t/strange-remote-build-issue/24387/4
    group = "remote-builder";

    # allow builders to actually access nix
    # todo: harden this somehow
    shell = pkgs.zsh;
  };

  users.groups.remote-builder = {};
}
