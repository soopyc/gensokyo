{ pkgs, ... }:
{
  default = pkgs.mkShellNoCC {
    packages = [
      pkgs.nixos-rebuild
      pkgs.nvd
      pkgs.just-lsp
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
