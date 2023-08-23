{ pkgs, ... }:

{
  # Miscellaneous packages that do not have an option.
  # It is recommended to use packages.<package>.enable when possible.

  # To search for a specific package, run this command.
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    curl

    file
    ripgrep
    ack

    deno

    nvd
    just

    git-crypt
  ];

  programs.mtr.enable = true;
}
