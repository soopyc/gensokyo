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
      generator = (pkgs.formats.toml { }).generate "jj-config.toml";
      value = {
        user.name = "Sophie Cheung";
        user.email = "git@soopy.moe";

        ui.default-command = "status";
        ui.merge-editor = "mergiraf";

        # ui.pager = "less -R";

        templates.commit_trailers = ''
          format_signed_off_by_trailer(self)
        '';

        aliases =
          let
            mkAlias = doc: definition: {
              inherit doc;
              definition =
                if builtins.typeOf definition == "string" then lib.splitString " " definition else definition;
            };
          in
          {
            d = mkAlias "diff" "diff";
            g = mkAlias "Git" "git";
            gf = mkAlias "Git Fetch" "git fetch";
            gp = mkAlias "Git Push" "git push";
            l = mkAlias "log" "log";
            sh = mkAlias "show" "show";
            sq = mkAlias "squash" "squash";

            untrack = mkAlias "untrack files" "file untrack";
          };
      };
    })

    {
      hjem.users.cassie.xdg.config.files."hjem-zsh-glue.zsh".text = ''
        alias j='jj'
      '';
    }

    (lib.mkIf config.gensokyo.traits.gui (
      _utils.mkHjemConfig "cassie" "jj/config.toml" {
        value = {
          git.sign-on-push = true;

          signing = {
            # behavior = "own";
            behavior = "drop";

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
