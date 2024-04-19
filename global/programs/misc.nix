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

    # basic sysadmin utils
    file
    ripgrep
    ack
    du-dust
    parallel
    ouch
    borgbackup
    yubikey-manager

    # deno
    deno

    # command runners and utilities
    nvd
    just

    # attic
    inputs.attic.packages.${pkgs.system}.attic-client
  ];

  programs.mtr.enable = true;
}
