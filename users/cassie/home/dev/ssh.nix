{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false; # silent warning

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

      backup = {
        hostname = "koumakan";
        user = "forgejo";
        identitiesOnly = true;
        identityFile = "~/.ssh/id_minecraft_backup";
      };

      "*" = {
        forwardAgent = true;
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = true;
        userKnownHostsFile = "~/.ssh/known_hosts";
        # visualHostKey = true; # if this doesn't work im moving to hjem
      };
    };

    # extraConfig is config for the Host * block.
    ## n.b.: identitesonly and identityfile makes bootstrapping other devices hard esp.
    ##       if they're embedded or resource constrained.
    extraConfig = ''
      VisualHostKey = true; # if this doesn't work im moving to hjem
    '';
  };
}
