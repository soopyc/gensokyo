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
      userName = "Sophie Cheung";
      userEmail = "me@soopy.moe";

      # difftastic.enable = true;
      # delta.enable = true;
      diff-so-fancy = {
        enable = true;
        stripLeadingSymbols = false;
      };
    }

    (lib.mkIf traits.gui {
      signing = {
        signByDefault = true;
        key = inputs.self + "/creds/ssh/auth";
      };

      extraConfig = {
        gpg.format = "ssh";
      };
    })
  ];

  home.shellAliases = {
    # redo previous commit when something explodes, like my key died or something
    gcmm = "git commit -eF .git/COMMIT_EDITMSG";
  };
}
