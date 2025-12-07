{
  lib,
  traits,
  inputs,
  ...
}:
{
  programs.git = lib.mkMerge [
    {
      enable = true;

      settings = {
        user.name = "Sophie Cheung";
        user.email = "git@soopy.moe";
      };
    }

    (lib.mkIf traits.gui {
      settings = {
        gpg.format = "ssh";
        commit.gpgSign = true;
        tag.gpgSign = true;

        user.signingKey = inputs.self + "/creds/ssh/auth";
      };
    })
  ];

  programs.diff-so-fancy = {
    enable = true;
    enableGitIntegration = true;

    settings.stripLeadingSymbols = false;
  };

  home.shellAliases = {
    # redo previous commit when something explodes, like my key died or something
    gcmm = "git commit -eF .git/COMMIT_EDITMSG"; # FIXME: strip the thing after ------ 8< ------
  };
}
