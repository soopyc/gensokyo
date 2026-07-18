{ inputs, _system, ... }:
{
  environment = {
    # for usage globally
    etc."allowed-signers".text = ''
      # [i] this file is for commit verification in both gir and jj.
      # [i] both vcs uses the "git" namespace for the time being.
      # soopyc
      me@soopy.moe namespaces="git" ${builtins.readFile ../../creds/ssh/auth}
      git@soopy.moe namespaces="git" ${builtins.readFile ../../creds/ssh/auth}
    '';

    systemPackages = [
      # jujutsu
      inputs.nixpkgs-unstable.legacyPackages.${_system}.jujutsu
    ];
  };

  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      gpg.ssh.allowedSignersFile = "/etc/allowed-signers";

      rebase.autoStash = true;
    };
  };
}
