{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      gpg.ssh.allowedSignersFile = pkgs.writeText "soopyc.allowedsigners" ''
        me@soopy.moe namespaces="git" ${builtins.readFile ../../creds/ssh/auth}
      '';

      rebase.autoStash = true;
    };
  };
}
