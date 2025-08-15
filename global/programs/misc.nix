{ pkgs, ... }:
{
  # Miscellaneous packages that do not have an option.
  # It is recommended to use packages.<package>.enable when possible.

  environment.systemPackages = with pkgs; [
    # junk
    wget
    curl
    xh
    gh
    nil
    nvd
    nix-output-monitor
    python3
    ffmpeg-full
    ghostty.terminfo

    # irc
    catgirl
    pounce

    # basic sysadmin utils
    jq
    file
    ripgrep
    ack
    du-dust
    parallel
    cryptsetup
    borgbackup
    doggo
    libarchive
    unar
    man-pages
    htop-vim

    # security
    openssl
    yubikey-manager
    sops
    opensc

    # deno
    deno

    # command runners and utilities
    just
    inotify-tools
  ];

  programs.mtr.enable = true;
}
