{
  lib,
  traits,
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
        key = builtins.toFile "signing.pub" "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJxpXpPlPEZPfnw2mIuWJEy/C/5h1bb6pIMeFsHAICQ+lLdEkbBSeDXQuA8feLN0MJw8KaB9jqrJbYgFadV/nVA=";
      };

      extraConfig = {
        gpg.format = "ssh";
      };
    })
  ];
}
