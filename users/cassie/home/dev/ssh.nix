{...}: {
  programs.ssh = {
    enable = true;
    hashKnownHosts = true;

    matchBlocks = {
      # most intuitive design /s
      koumakan = {
        # host is set to the match block name by default but it is not in the manual/option docs.
        hostname = "cirno.soopy.moe";
      };

      patchy = {
        hostname = "patchy.soopy.moe";
        user = "forgejo";
      };

      gh = {
        hostname = "github.com";
        user = "git";
      };
    };

    # extraConfig is config for the Host * block.
    extraConfig = ''
      VisualHostKey yes
      IdentitiesOnly yes
      IdentityFile ${../../../../creds/ssh/auth}
    ''; # ^ least insane relative directory link
  };
}
