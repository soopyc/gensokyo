{pkgs, ...}: {
  imports = [
    ./git.nix
    ./ssh.nix
    ./editors.nix
  ];

  home.packages = with pkgs; [
    mdbook
    mdbook-admonish
    mdbook-pagetoc
  ];
}
