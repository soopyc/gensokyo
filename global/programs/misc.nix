{
  pkgs,
  inputs,
  ...
}: {
  # Miscellaneous packages that do not have an option.
  # It is recommended to use packages.<package>.enable when possible.

  environment.systemPackages = with pkgs; [
    # junk
    wget
    curl
    xh
    nil
    nix-output-monitor
    python3
    ffmpeg
    inputs.ghostty.packages.${pkgs.system}.default.terminfo

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
    man-pages

    # security
    openssl
    yubikey-manager
    sops
    opensc

    # deno
    deno
    devenv

    # command runners and utilities
    nvd
    just
    inotify-tools
  ];

  programs.mtr.enable = true;
}
