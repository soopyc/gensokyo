{
  lib,
  traits,
  inputs,
  ...
}: {
  programs.git = lib.mkMerge [
    {
      enable = true;
      userName = "Cassie Cheung";
      userEmail = "me@soopy.moe";

      difftastic.enable = true;
      # delta.enable = true;
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
}
