{ ... }:
{
  programs.ssh = {
    enable = true;
    hashKnownHosts = true;
    forwardAgent = true;

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
    ## n.b.: identitesonly and identityfile makes bootstrapping other devices hard esp.
    ##       if they're embedded or resource constrained.
    extraConfig = ''
      VisualHostKey yes
    '';
  };
}
