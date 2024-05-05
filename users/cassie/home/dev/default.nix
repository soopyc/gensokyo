{pkgs, ...}: {
  imports = [
    ./git.nix
    ./ssh.nix
  ];

  home.packages = with pkgs; [
    mdbook-admonish
    mdbook-pagetoc
  ];
}
