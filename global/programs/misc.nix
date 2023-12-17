{pkgs, ...}: {
  # Miscellaneous packages that do not have an option.
  # It is recommended to use packages.<package>.enable when possible.

  # To search for a specific package, run this command.
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # junk
    wget
    curl
    xh

    # basic sysadmin utils
    file
    ripgrep
    ack
    du-dust
    parallel

    # deno
    deno

    # command runners and utilities
    nvd
    just

    # attic
    attic
  ];

  programs.mtr.enable = true;
}
