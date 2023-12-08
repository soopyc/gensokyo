{pkgs, ...}: {
  # Miscellaneous packages that do not have an option.
  # It is recommended to use packages.<package>.enable when possible.

  # To search for a specific package, run this command.
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    curl
    xh

    file
    ripgrep
    ack

    deno

    nvd
    just

    attic
  ];

  programs.mtr.enable = true;
}
