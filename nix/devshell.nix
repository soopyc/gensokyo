{ pkgs, ... }:
{
  default = pkgs.mkShellNoCC {
    packages = with pkgs; [
      nixos-rebuild
      dix
      just-lsp
      nixfmt
    ];
  };

  docs = pkgs.mkShellNoCC {
    packages = with pkgs; [
      mdbook
      mdbook-admonish
      mdbook-pagetoc
    ];
  };
}
