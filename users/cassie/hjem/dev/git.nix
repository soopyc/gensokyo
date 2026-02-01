{
  lib,
  pkgs,
  inputs,
  config,
  _utils,
  ...
}:
let
  diff-so-fancy = lib.getExe pkgs.diff-so-fancy;
  less = lib.getExe pkgs.less;
in
{
  imports = [
    (_utils.mkHjemConfig "cassie" "git/config" {
      generator = lib.generators.toGitINI;
      value = {
        user.name = "Sophie Cheung";
        user.email = "git@soopy.moe";
      };
    })
    (lib.mkIf config.gensokyo.traits.gui (
      _utils.mkHjemConfig "cassie" "git/config" {
        value = {
          user.signingKey = inputs.self + "/creds/ssh/auth";
          gpg.format = "ssh";
          # i probably don't need to set 'gpg "openpgp"'.program here since i don't use gpg
          # ... how am i even supposed to set that?? don't tell me i have to write that cursed line
          # update: it looks like it is indeed that cursed thing...

          commit.gpgSign = true;
          tag.gpgSign = true;

          # diff-so-fancy stuff
          diff-so-fancy.stripLeadingSymbols = false;
          core.pager = "${diff-so-fancy} | ${less} '--tabs=4' -RFX"; # in order: raw control chars, quit if one screen, don't init terminal
          interactive.diffFilter = "${diff-so-fancy} --patch";
        };
      }
    ))
  ];
}
