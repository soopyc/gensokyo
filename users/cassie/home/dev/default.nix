{pkgs, ...}: {
  imports = [
    ./git.nix
    ./ssh.nix
  ];

  home.packages = with pkgs; [
    mdbook
    mdbook-admonish
    mdbook-pagetoc
  ];
}
