{
  hjem.users.cassie.files.".ssh/config".text = ''
    Host patchy
      Hostname koumakan
      User     forgejo

    Host gh
      Hostname github.com
      User     git

    Host kita
      Compression   yes

    Host *
      ForwardAgent       yes
      Compression        false
      VisualHostKey      yes
      UserKnownHostsFile ~/.ssh/known_hosts

      # annoying
      TCPKeepAlive       no
  '';
}
