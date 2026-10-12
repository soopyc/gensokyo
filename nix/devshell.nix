{
  pkgs,
  inputs,
  system,
  ...
}:
{
  default = pkgs.mkShellNoCC {
    packages = with pkgs; [
      nixVersions.latest

      nixos-rebuild
      dix
      just-lsp
      nixfmt
      compose2nix

      (inputs.nixpkgs-unstable.legacyPackages.${system}.python3.withPackages (
        p: with p; [
          ipython
          requests
          icalendar
        ]
      ))
      inputs.nixpkgs-unstable.legacyPackages.${system}.just
      inputs.niks3.packages.${system}.default
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
