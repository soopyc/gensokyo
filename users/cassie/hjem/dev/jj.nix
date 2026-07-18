{
  lib,
  pkgs,
  inputs,
  config,
  _utils,
  ...
}:
{
  imports = [
    (_utils.mkHjemConfig "cassie" "jj/config.toml" {
      generator = (pkgs.formats.toml { }).generate;
      value = {
        user.name = "Sophie Cheung";
        user.email = "git@soopy.moe";

        # ui.pager = "less -R";

        templates.commit_trailers = ''
          format_signed_off_by_trailer(self)
        '';
      };
    })

    (lib.mkIf config.gensokyo.traits.gui (
      _utils.mkHjemConfig "cassie" "jj/config.toml" {
        value = {
          git.sign-on-push = true;

          signing = {
            behavior = "own";

            backend = "ssh";
            key = inputs.self + "/creds/ssh/auth";
            backends.ssh = {
              allowed-signers = "/etc/allowed-signers"; # see <global/programs/scm.nix>
            };
          };
        };
      }
    ))
  ];
}
