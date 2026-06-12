{ pkgs, inputs, system, ... }:
{
  default = pkgs.mkShellNoCC {
    packages = with pkgs; [
      nixos-rebuild
      dix
      just-lsp
      nixfmt

      inputs.nixpkgs-unstable.legacyPackages.${system}.just
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
