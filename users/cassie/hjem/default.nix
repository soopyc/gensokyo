{
  imports = [
    ./dev

    ./lsd.nix
    ./zsh.nix
  ];

  hjem.users.cassie = {
    user = "cassie";
    directory = "/home/cassie";
    systemd.enable = false; # FIXME: enable after migration of most hm stuff
  };
}
