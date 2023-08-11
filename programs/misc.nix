{ pkgs, ... }:

{
  # Miscellaneous packages that do not have an option. 
  # It is recommended to use packages.<package>.enable when possible.

  # To search for a specific package, run this command.
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    curl

    cope  # colo[u]rs!!

    file
    ripgrep
    ack

    git-crypt
  ];
}
