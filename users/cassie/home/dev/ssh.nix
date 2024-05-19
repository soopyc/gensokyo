{...}: {
  programs.ssh = {
    enable = true;
    hashKnownHosts = true;

    matchBlocks = {
      # most intuitive design /s
      patchy = {
        # host is set to the match block name by default but it is not in the manual/option docs.
        hostname = "koumakan";
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
