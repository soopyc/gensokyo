{
  inputs,
  pkgs,
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

    # basic sysadmin utils
    jq
    file
    ripgrep
    ack
    du-dust
    parallel
    ouch
    cryptsetup
    borgbackup

    # security
    openssl
    yubikey-manager
    sops

    # deno
    deno
    devenv

    # command runners and utilities
    nvd
    just
    inotify-tools

    # attic
    inputs.attic.packages.${pkgs.system}.attic-client
  ];

  programs.mtr.enable = true;
}
